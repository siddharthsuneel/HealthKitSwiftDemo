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
        
        //Nutritions
        
        let readSet:Set = [stepsCount, distanceWalkRunning, distanceCycling, basalEnergyBurned, activeEnergyBurned, flightsClimbed, heartRate, bodyTemperature, respiratoryRate]
        
        return readSet
    }
    
    func writeDataTypes() -> Set<HKSampleType> {
    
        let stepsCount: HKQuantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        let height: HKQuantityType              = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
        let weight: HKQuantityType              = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        let biologicalSex:HKCharacteristicType  = HKCharacteristicType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!
        let dateOfBirth:HKCharacteristicType    = HKCharacteristicType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!
        let bloodType:HKCharacteristicType      = HKCharacteristicType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType)!
        let fatPercentage: HKQuantityType       = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyFatPercentage)!
        let bmi: HKQuantityType                 = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMassIndex)!
        
        
        let writeSet:Set = [stepsCount, height, weight, biologicalSex, dateOfBirth, bloodType, fatPercentage, bmi]
        
        return writeSet as! Set<HKSampleType>
    }
    
    //MARK: Reading HealthKit Data
    func getData() -> Int{
        var bloodObject:HKBloodTypeObject?
        do {
            try bloodObject = healthStore.bloodType()
        } catch {
            
        }
        
        let bloodType = bloodObject?.bloodType.rawValue ?? -1
        return bloodType
    }
    
    
    //MARK: Writing HealthKit Data
    
    func saveStepsCountData() {
        //Pick a random number between 0-500
        let count = arc4random() % 500
        
        //Set the measuring unit
        let countUnit:HKUnit = HKUnit.count()
        
        //Set the quantity to update/save
        let steps:HKQuantity = HKQuantity.init(unit: countUnit, doubleValue: Double(count))
        
        //Select the quantity type using identifier to update
        let stepsCount: HKQuantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        let now = Date() //today's date
        
        //Create a sample to save
        let stepCountSample: HKQuantitySample = HKQuantitySample.init(type: stepsCount, quantity: steps, start: now, end: now)
        
        healthStore.save(stepCountSample, withCompletion: { (success,error) -> Void in
            if !success {
                print("Failed to update the steps count in the health store")
            }
        })
    }
    
}
