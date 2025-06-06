//
//  CoreMotionPlugin.swift
//  CoreMotionPlugin
//
//  Created by Fatakhillah Khaqo on 29/10/24.
//

import Foundation
import CoreMotion

class CoreMotionManager: ObservableObject {
    private var motionManager = CMMotionManager()
    private var updateInterval = 1.0 / 60.0  // 60 Hz update rate
    
    @Published var roll: Double = 0.0
    @Published var pitch: Double = 0.0
    @Published var yaw: Double = 0.0
    
    // Singleton instance to maintain state across calls
    static let shared = CoreMotionManager()
    
    private init() {
        startGyroUpdates()
    }
    
    func startGyroUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = updateInterval
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motionData, error in
                guard let self = self, let motion = motionData else { return }
                
                // Extract roll, pitch, and yaw from device's attitude
                self.roll = motion.attitude.roll
                self.pitch = motion.attitude.pitch
                self.yaw = motion.attitude.yaw
            }
        }
    }
    
    func stopGyroUpdates() {
        if motionManager.isDeviceMotionActive {
            motionManager.stopDeviceMotionUpdates()
        }
    }
}

// Exposing the Published variables to Unity

@_cdecl("GetRoll")
public func GetRoll() -> Double {
    return CoreMotionManager.shared.roll
}

@_cdecl("GetPitch")
public func GetPitch() -> Double {
    return CoreMotionManager.shared.pitch
}

@_cdecl("GetYaw")
public func GetYaw() -> Double {
    return CoreMotionManager.shared.yaw
}

@_cdecl("StartGyroUpdates")
public func StartGyroUpdates() {
    CoreMotionManager.shared.startGyroUpdates()
}

@_cdecl("StopGyroUpdates")
public func StopGyroUpdates() {
    CoreMotionManager.shared.stopGyroUpdates()
}
