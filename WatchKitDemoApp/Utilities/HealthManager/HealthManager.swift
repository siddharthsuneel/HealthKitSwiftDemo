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
    
    func readMostRecentSampleData(sampleType:HKSampleType, completion:@escaping ((HKSample?,NSError?) -> Void)) {
        
        // 1. Build the Predicate
//        let past = Date.distantPast as Date
//        let now   = Date()
//        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: past, end: now, options: HKQueryOptions.init(rawValue: 0))
        
        // 2. Build the sort descriptor to return the samples in descending order
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        
        // 3. we want to limit the number of samples returned by the query to just 1 (the most recent)
        let limit = 1
        
        // 4. Build samples query
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: nil, limit: limit, sortDescriptors: [sortDescriptor]) { (sampleQuery, results, error ) -> Void in
            
            if let queryError = error {
                completion(nil,queryError as NSError?)
                return;
            }
            
            // Get the first sample
            let mostRecentSample = results?.first as? HKQuantitySample
            
            // Execute the completion closure
            completion(mostRecentSample,nil)
        }
        // 5. Execute the Query
        self.healthStore.execute(sampleQuery)
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
        
        let activitySummary:HKObjectType        = HKObjectType.activitySummaryType()
        
        let readSet:Set = [height, weight, stepsCount, distanceWalkRunning, distanceCycling, basalEnergyBurned, activeEnergyBurned, flightsClimbed, heartRate, bodyTemperature, respiratoryRate, biologicalSex, dateOfBirth, bloodType, activitySummary]
        
        return readSet
    }
    
    func writeDataTypes() -> Set<HKSampleType> {
        
        let stepsCount: HKQuantityType          = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        let height: HKQuantityType              = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
        let weight: HKQuantityType              = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        let fatPercentage: HKQuantityType       = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyFatPercentage)!
        let bmi: HKQuantityType                 = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMassIndex)!
        
        
        
        let activeEnergyBurned:HKQuantityType              = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
        
        let walkingDistance:HKQuantityType              = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!
        
        let workout:HKObjectType = HKObjectType.workoutType()


        
        let writeSet:Set = [stepsCount, height, weight, fatPercentage, bmi, activeEnergyBurned, walkingDistance, workout]
        
        return writeSet as! Set<HKSampleType>
    }
    
    //MARK: Reading HealthKit Data
    fileprivate func getBloodTypeData() -> String{
        var bloodObject:HKBloodTypeObject?
        do {
            try bloodObject = healthStore.bloodType()
        } catch {
            print("Error: Not able to read blood type.")
        }
        
        let bloodType = bloodObject?.bloodType.rawValue ?? -1
        return mapBloodType(type: HKBloodType(rawValue: bloodType))
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
                print("Error: Failed to update the steps count in the health store")
            }
        })
    }
    
    //MARK: Private Methods
    fileprivate func mapBloodType(type:HKBloodType?) -> String {
        var bloodTypeText = "Unknown"
        
        if type != nil {
            
            switch type! {
            case .aPositive:
                bloodTypeText = "A+"
            case .aNegative:
                bloodTypeText = "A-"
            case .bPositive:
                bloodTypeText = "B+"
            case .bNegative:
                bloodTypeText = "B-"
            case .abPositive:
                bloodTypeText = "AB+"
            case .abNegative:
                bloodTypeText = "AB-"
            case .oPositive:
                bloodTypeText = "O+"
            case .oNegative:
                bloodTypeText = "O-"
            default:
                bloodTypeText = "Not set"
                break;
            }
            
        }
        return bloodTypeText;
    }
    
    fileprivate func mapBiologicalSex(type:HKBiologicalSex?) -> String {
        var biologicalSex = "Unknown"
        
        if type != nil {
            switch type! {
            case .female:
                biologicalSex = "Female"
            case .male:
                biologicalSex = "Male"
            case .other:
                biologicalSex = "Other"
            case .notSet:
                biologicalSex = "Not set"
            }
        }
        return biologicalSex
    }
    
    //MARK: Public Methods
    
    func getProfileData() -> (age:Int, bioSex:String, bloodType:String){
        let age:Int?
        
        //Age
        let birthDate:DateComponents?
        do {
            try birthDate = healthStore.dateOfBirthComponents()
            let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
            let date = calendar?.date(from: birthDate!)
            age = Calendar.current.dateComponents([.year], from: date!, to: Date()).year!
        } catch {
            print("Error: Not able to read DOB")
            age = -1
        }
        
        //Biological Sex
        var biologicalSexObject:HKBiologicalSexObject?
        do {
            try biologicalSexObject = healthStore.biologicalSex()
        } catch {
            print("Error: Not able to read Biological Sex")
        }
        let biologicalSex = biologicalSexObject?.biologicalSex.rawValue ?? -1
        
        return (age!, mapBiologicalSex(type: HKBiologicalSex(rawValue: biologicalSex)), getBloodTypeData())
    }
    
    func getHeightData(successBlock: @escaping ((HKQuantitySample,String) -> Void)) {
        var height: HKQuantitySample?
        
        let heightSample = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)
        readMostRecentSampleData(sampleType: heightSample!, completion: {(mostRecentHeightSample, error) -> Void in
            if( error != nil ) {
                print("Error reading height from HealthKit Store: \(error?.localizedDescription)")
                return;
            }
            height = mostRecentHeightSample as? HKQuantitySample
            if let meters = height?.quantity.doubleValue(for: HKUnit.meter()) {
                let heightFormatter = LengthFormatter()
                heightFormatter.isForPersonHeightUse = true
                successBlock(height!,heightFormatter.string(fromMeters: meters))
            }
        })
    }
    
    func getWeightData(successBlock: @escaping ((HKQuantitySample,String) -> Void)) {
        var weight: HKQuantitySample?
        
        let weightSample = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)
        readMostRecentSampleData(sampleType: weightSample!, completion: {(mostRecentWeightSample, error) -> Void in
            if( error != nil ) {
                print("Error reading weight from HealthKit Store: \(error?.localizedDescription)")
                return;
            }
            weight = mostRecentWeightSample as? HKQuantitySample
            if let kilogram = weight?.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo)) {
                let massFormatter = MassFormatter()
                massFormatter.isForPersonMassUse = true
                successBlock(weight!,massFormatter.string(fromKilograms: kilogram))
            }
        })
    }
    
    func saveBMISample(bmi:Double, date:NSDate ) {
        
        // 1. Create a BMI Sample
        let bmiType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMassIndex)
        let bmiQuantity = HKQuantity(unit: HKUnit.count(), doubleValue: bmi)
        let bmiSample = HKQuantitySample(type: bmiType!, quantity: bmiQuantity, start: date as Date, end: date as Date)
        
        // 2. Save the sample in the store
        healthStore.save(bmiSample, withCompletion: { (success, error) -> Void in
            if( error != nil ) {
                print("Error saving BMI sample: \(error?.localizedDescription)")
            } else {
                print("BMI sample saved successfully!")
            }
        })
    }

    
}
