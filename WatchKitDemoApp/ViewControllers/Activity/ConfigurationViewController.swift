//
//  ConfigurationViewController.swift
//  WatchKitDemoApp
//
//  Created by Saurabh Satwani on 01/03/17.
//  Copyright © 2017 Saurabh Satwani. All rights reserved.
//


import UIKit
import HealthKit

class ConfigurationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: Properties
    
    var selectedActivityType: HKWorkoutActivityType?
    
    var selectedLocationType: HKWorkoutSessionLocationType?
    
    let activityTypes: [HKWorkoutActivityType] = [.walking, .running, .hiking]
    let locationTypes: [HKWorkoutSessionLocationType] = [.unknown, .indoor, .outdoor]
    
    // MARK: IBOutlets
    
    
    @IBOutlet var activityTypePicker: UIPickerView!
    @IBOutlet var locationTypePicker: UIPickerView!

    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedActivityType = activityTypes[0]
        selectedLocationType = locationTypes[0]        // Do any additional setup after loading the view.
    }
    
    
    func format(activityType: HKWorkoutActivityType) -> String {
        let formattedType : String
        
        switch activityType {
        case .walking:
            formattedType = "Walking"
            
        case .running:
            formattedType = "Running"
            
        case .hiking:
            formattedType = "Hiking"
            
        default:
            formattedType = "Workout"
        }
        
        return formattedType
    }
    
    
    func format(locationType: HKWorkoutSessionLocationType) -> String {
        let formattedType : String
        
        switch locationType {
        case .indoor:
            formattedType = "Indoor"
            
        case .outdoor:
            formattedType = "Outdoor"
            
        case .unknown:
            formattedType = "Unknown"
        }
        
        return formattedType
    }


    // MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == activityTypePicker {
            return activityTypes.count
        } else if pickerView == locationTypePicker {
            return locationTypes.count
        }
        
        return 0
    }

    // MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == activityTypePicker {
            return format(activityType: activityTypes[row])
        } else if pickerView == locationTypePicker {
            return format(locationType: locationTypes[row])
        }
        
        return nil
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == activityTypePicker {
            selectedActivityType = activityTypes[row]
        } else if pickerView == locationTypePicker {
            selectedLocationType = locationTypes[row]
        }
    }
    
    @IBAction func didTapStartButton() {
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = selectedActivityType!
        workoutConfiguration.locationType = selectedLocationType!
        
        if let workoutViewController = storyboard?.instantiateViewController(withIdentifier: "WorkoutViewController") as? WorkoutViewController {
            workoutViewController.configuration = workoutConfiguration
            present(workoutViewController, animated: true, completion:nil)
        }
    }
}

