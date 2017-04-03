//
//  HKQuantityTypeExtension.swift
//  WatchKitDemoApp WatchKit Extension
//
//  Created by Siddharth suneel on 16/03/17.
//  Copyright © 2017 Siddharth suneel. All rights reserved.
//

import Foundation
import HealthKit

extension HKQuantityType {
    static func distanceWalkingRunning() -> HKQuantityType {
        return HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!
    }
    
    static func distanceCycling() -> HKQuantityType {
        return HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceCycling)!
    }
    
    static func activeEnergyBurned() -> HKQuantityType {
        return HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
    }
    
    static func heartRate() -> HKQuantityType {
        return HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
    }
}
