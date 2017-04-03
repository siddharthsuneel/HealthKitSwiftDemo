//
//  ExtensionDelegate.swift
//  WatchKitDemoApp WatchKit Extension
//
//  Created by Siddharth suneel on 01/03/17.
//  Copyright © 2017 Siddharth suneel. All rights reserved.
//

import WatchKit
import HealthKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    let healthStore:HKHealthStore = HKHealthStore()
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        authoriseHealthKit()
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompleted()
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompleted()
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompleted()
            default:
                // make sure to complete unhandled task types
                task.setTaskCompleted()
            }
        }
    }
    
    func handle(_ workoutConfiguration: HKWorkoutConfiguration) {
        WKInterfaceController.reloadRootControllers(withNames: ["WorkoutInterfaceController"], contexts: [workoutConfiguration])
    }

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
        
        //Profile
        let height: HKQuantityType              = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
        let weight: HKQuantityType              = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        
        //Physical activity
        let stepsCount: HKQuantityType              = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        let distanceWalkRunning: HKQuantityType     = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!
        let distanceCycling: HKQuantityType         = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceCycling)!
        
        //Calories
        let basalEnergyBurned: HKQuantityType       = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.basalEnergyBurned)!
        let activeEnergyBurned: HKQuantityType      = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
        let flightsClimbed: HKQuantityType          = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.flightsClimbed)!
        
        //Vitals
        let heartRate: HKQuantityType               = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        let bodyTemperature: HKQuantityType         = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyTemperature)!
        let respiratoryRate: HKQuantityType         = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.respiratoryRate)!
        
        
        let biologicalSex:HKObjectType          = HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!
        let dateOfBirth:HKObjectType            = HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!
        let bloodType:HKObjectType              = HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType)!
        
        
        let readSet:Set = [height, weight, stepsCount, distanceWalkRunning, distanceCycling, basalEnergyBurned, activeEnergyBurned, flightsClimbed, heartRate, bodyTemperature, respiratoryRate, biologicalSex, dateOfBirth, bloodType]
        
        return readSet
    }
    
    func writeDataTypes() -> Set<HKSampleType> {
        
        let stepsCount: HKQuantityType          = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        let height: HKQuantityType              = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
        let weight: HKQuantityType              = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        let fatPercentage: HKQuantityType       = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyFatPercentage)!
        let bmi: HKQuantityType                 = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMassIndex)!
        //        let workout:HKQuantityType              = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.)
        
        let writeSet:Set = [stepsCount, height, weight, fatPercentage, bmi]
        
        return writeSet
    }

}
