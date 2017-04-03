//
//  SummaryInterfaceController.swift
//  WatchKitDemoApp
//
//  Created by Siddharth suneel on 16/03/17.
//  Copyright © 2017 Siddharth suneel. All rights reserved.
//

import UIKit
import WatchKit
import HealthKit

class SummaryInterfaceController: WKInterfaceController {

    var workout: HKWorkout?
    let healthStore:HKHealthStore = HKHealthStore()
    
    //IBOutlets
    @IBOutlet var workoutLabel: WKInterfaceLabel!
    @IBOutlet var durationLabel: WKInterfaceLabel!
    @IBOutlet var caloriesLabel: WKInterfaceLabel!
    @IBOutlet var distanceLabel: WKInterfaceLabel!
    @IBOutlet var doneButton: WKInterfaceButton!
    @IBOutlet var activityRing: WKInterfaceActivityRing!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        workout = context as? HKWorkout
        
        setTitle("Summary")
    }
    
    override func willActivate() {
        super.willActivate()
        
        guard let workout = workout else { return }
        
        setupActivityRing()
        workoutLabel.setText("\(format(activityType: workout.workoutActivityType))")
        caloriesLabel.setText(format(energy: workout.totalEnergyBurned!))
        distanceLabel.setText(format(distance: workout.totalDistance!))
        
        let duration = computeDurationOfWorkout(withEvents: workout.workoutEvents, startDate: workout.startDate, endDate: workout.endDate)
        durationLabel.setText(format(duration: duration))
    }
    
    func setupActivityRing() {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.era, .year, .month, .day], from: Date())
        components.calendar = calendar
        
        let predicate = NSPredicate.init(format: "%K = %@", HKPredicateKeyPathDateComponents, components as CVarArg)
        
        let query = HKActivitySummaryQuery.init(predicate: predicate, resultsHandler: {query, summaries, error in
            guard let todaysActivitySummary = summaries?.first else {
                return
            }
            print(todaysActivitySummary)
            self.activityRing.setActivitySummary(todaysActivitySummary, animated: true)
        })
        
        healthStore.execute(query)
        
    }
    
    @IBAction func didTappedDoneButton() {
        WKInterfaceController.reloadRootControllers(withNames: ["InterfaceController"], contexts: nil)
        
//        NSMutableArray *dataSources = [[NSMutableArray alloc], init];
//        HKQuantityType *stepsCount = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
//        HKSourceQuery *sourceQuery = [[HKSourceQuery alloc] initWithSampleType:stepsCount
//        samplePredicate:nil
//        completionHandler:^(HKSourceQuery *query, NSSet *sources, NSError *error)
//        {
//        for (HKSource *source in sources)
//        {
//        if (![source.bundleIdentifier isEqualToString:@"com.apple.Health"])
//        {
//        [dataSources addObject:source];
//        }
//        }
//        }];
//        [self.healthStore executeQuery:sourceQuery];
        
        
        let dataSources:NSMutableArray = NSMutableArray()
        let distance:HKQuantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!
        let sourceQuery:HKSourceQuery = HKSourceQuery.init(sampleType: distance, samplePredicate: nil) { (query, sources, error) in
            for source in sources!{
                if source.bundleIdentifier == "com.dmi.WatchKitDemoApp"{
                dataSources.add(source)
                    
                    let appSource:HKSource = dataSources[0] as! HKSource
                    
                    
                    let sourcePredicate = HKQuery.predicateForObjects(from: appSource)
                    let queryPredicate = NSCompoundPredicate(andPredicateWithSubpredicates:[sourcePredicate])
                    
                    let updateHandler: ((HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void) = { query, samples, deletedObjects, queryAnchor, error in
                        self.process(samples: samples, quantityTypeIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)
                    }
                    
                    let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
                                                      predicate: queryPredicate,
                                                      anchor: nil,
                                                      limit: HKObjectQueryNoLimit,
                                                      resultsHandler: updateHandler)
                    query.updateHandler = updateHandler
                    self.healthStore.execute(query)
                    
                    
                    
            }
            }
        }
        
        healthStore.execute(sourceQuery)
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    func process(samples: [HKSample]?, quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        DispatchQueue.main.async { [weak self] in
            
            if let quantitySamples = samples as? [HKQuantitySample] {
                for sample in quantitySamples {
                    if quantityTypeIdentifier == HKQuantityTypeIdentifier.distanceWalkingRunning {
                        let newMeters = sample.quantity.doubleValue(for: HKUnit.meter())
                        print(newMeters)
                    }
                }
                
            }
        }
    }

    
    
    
}
