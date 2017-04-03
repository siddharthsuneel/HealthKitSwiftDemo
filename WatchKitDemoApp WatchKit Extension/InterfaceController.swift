//
//  InterfaceController.swift
//  WatchKitDemoApp WatchKit Extension
//
//  Created by Siddharth suneel on 01/03/17.
//  Copyright © 2017 Siddharth suneel. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit

class InterfaceController: WKInterfaceController {

    //IBOutlets
    @IBOutlet var activityPicker: WKInterfacePicker!
    @IBOutlet var locationPicker: WKInterfacePicker!
    @IBOutlet var startButton: WKInterfaceButton!
    
    //Properties
    var selectedActivityType: HKWorkoutActivityType?
    var selectedLocationType: HKWorkoutSessionLocationType?
    
    let activityData: [HKWorkoutActivityType] = [.walking, .running, .hiking]
    let locationData: [HKWorkoutSessionLocationType] = [.unknown, .indoor, .outdoor]

    //MARK: Initialisation
    override init() {
        super.init()
        
        selectedActivityType = activityData[0]
        selectedLocationType = locationData[0]
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        // Populate the activity type picker
        let activityTypePickerItems: [WKPickerItem] = activityData.map {type in
            let pickerItem = WKPickerItem()
            pickerItem.title = format(activityType: type)
            return pickerItem
        }
        activityPicker.setItems(activityTypePickerItems)
        
        // Populate the location type picker
        let locationTypePickerItems: [WKPickerItem] = locationData.map {type in
            let pickerItem = WKPickerItem()
            pickerItem.title = format(locationType: type)
            return pickerItem
        }
        locationPicker.setItems(locationTypePickerItems)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    //MARK: IBActions
    @IBAction func didChangedActivityTypePickerValue(_ value: Int) {
        selectedActivityType = activityData[value]
    }
    
    @IBAction func didChangedLocationTypePickerValue(_ value: Int) {
        selectedLocationType = locationData[value]
    }
    
    @IBAction func didTappedStartButton() {
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = selectedActivityType!
        workoutConfiguration.locationType = selectedLocationType!
        
        WKInterfaceController.reloadRootControllers(withNames: ["WorkoutInterfaceController"], contexts: [workoutConfiguration])
    }
}
