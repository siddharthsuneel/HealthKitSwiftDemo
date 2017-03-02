//
//  HealthManager.swift
//  WatchKitDemoApp
//
//  Created by Siddharth suneel on 01/03/17.
//  Copyright © 2017 Siddharth suneel. All rights reserved.
//

import Foundation
import HealthKit

class HealthManager {
    
    let healthStore:HKHealthStore = HKHealthStore()
    
    
    func authoriseHealthKit() {
        
        if HKHealthStore.isHealthDataAvailable() {
            
            let readTypes:Set<HKObjectType> = readDataTypes()
            let writeTypes:Set<HKSampleType> = writeDataTypes()
            
            //reuest authorisation
            healthStore.requestAuthorization(toShare: writeTypes, read: readTypes, completion: { (success,error) -> Void in
                if !success {
                    print("You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: %@. If you're using a simulator, try it on a device.", error!)
                }
                
                //TODO: update reuired UI elements here...
            })
        }
    }
    
    //MARK: HealthKit Permissions
    
    func readDataTypes() -> Set<HKObjectType> {
        
        let stepsCount: HKQuantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        let readSet:Set = [stepsCount]
        
        return readSet
    }
    
    func writeDataTypes() -> Set<HKSampleType> {
        
        let height: HKQuantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
        
        let writeSet:Set = [height]
        
        return writeSet
    }
}
