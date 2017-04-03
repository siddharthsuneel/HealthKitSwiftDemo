//
//  ProfileViewController.swift
//  WatchKitDemoApp
//
//  Created by Siddharth suneel on 03/03/17.
//  Copyright © 2017 Siddharth suneel. All rights reserved.
//

import UIKit
import HealthKit

class ProfileViewController: UIViewController {
    
    let kUnknownString = "Unknown"
    let healthManager = HealthManager()
    var profileDataModel:ProfileDataModel = ProfileDataModel()
    var isEditButtonClicked = false
    let bloodGroupArray = ["O-","O+","A-","A+","B-","B+","AB-","AB+"]
    let genderArray = ["Male","Female"]
    var weightSampleValue:HKQuantitySample!
    var heightSampleVaue:HKQuantitySample!
    var bmiDoubleValue:Double!
    
  
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    fileprivate func setup() {
        tableView.register(UINib(nibName: Constants.ProfileCustomTableViewCellNibName,bundle: nil), forCellReuseIdentifier: Constants.ProfileCustomTableViewCellID)
        tableView.tableFooterView = UIView()
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ProfileCustomTableViewCellID) as!ProfileCustomTableViewCell
        cell.delegate = self
        
        let editBarButtonItem = UIBarButtonItem.init(title: "Edit",style:.plain,target:self,action: #selector(ProfileViewController.editButtonAction(sender:)))
        self.navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    func configureActionSheet(forindex: IndexPath) {
        
        let actionSheetController = UIAlertController(title: "", message :"", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title : "Cancel" ,style :.cancel ){action -> Void in
        }
        if forindex.row == 2{
            for title in bloodGroupArray {
                let bloodGroupAction = UIAlertAction(title: title, style: .default) { (action) in
                self.profileDataModel.bloodType = title
                self.tableView.reloadData()
                
                }
                actionSheetController.addAction(bloodGroupAction)
                
            }
        }
        else if forindex.row == 1{
            for title in genderArray {
                let bloodGroupAction = UIAlertAction(title: title, style: .default) { (action) in
                    self.profileDataModel.biologicalSex = title
                    self.tableView.reloadData()
                }
                actionSheetController.addAction(bloodGroupAction)
            }
   
        }
        actionSheetController.addAction(cancelActionButton)
        self.present(actionSheetController, animated: true, completion:nil)
    }
    
    func editButtonAction(sender :UIBarButtonItem) {
           if sender.title == "Edit"{
            isEditButtonClicked = true
            sender.title = "Cancel"
        }
        else {
            isEditButtonClicked = false
            sender.title = "Edit"
        }
        tableView.reloadData()
 
    }
    
    //MARK: BMI Calculations
    
    func updateBMI()
    {
        if self.weightSampleValue != nil && self.heightSampleVaue != nil {
            // 1. Get the weight and height values from the samples read from HealthKit
            let weightInKilograms = self.weightSampleValue!.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
            let heightInMeters = self.heightSampleVaue!.quantity.doubleValue(for: HKUnit.meter())
            // 2. Call the method to calculate the BMI
            
            bmiDoubleValue = calculateBMIWithWeightInKilograms(weightInKilograms: weightInKilograms, heightInMeters: heightInMeters)
            profileDataModel.BMI  = String(format: "%.02f",bmiDoubleValue!)
            
            tableView.reloadData()
        }
    }
    
    func calculateBMIWithWeightInKilograms(weightInKilograms:Double, heightInMeters:Double) -> Double?
    {
        if heightInMeters == 0 {
            return nil;
        }
        return (weightInKilograms/(heightInMeters*heightInMeters));
    }
    
    func saveHealthKitData(){
        
        if profileDataModel.BMI != nil {
            healthManager.saveBMISample(bmi: bmiDoubleValue, date: NSDate())
        }
        else {
            print("There is no BMI data to save")
        }
        
    }
    
}

//MARK: UITableViewDataSource Methods

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 3
        }else {
            return 1
        }
    }
    
     @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ProfileCustomTableViewCell = {
            guard let cell1 = tableView.dequeueReusableCell(withIdentifier: Constants.ProfileCustomTableViewCellID) else {
                return UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: Constants.ProfileCustomTableViewCellID) as! ProfileCustomTableViewCell
            }
            return cell1 as! ProfileCustomTableViewCell
        }()
        cell.isUserInteractionEnabled = isEditButtonClicked
        cell.userTextField.delegate? = self as UITextFieldDelegate
        cell.userTextField.tag = indexPath.row
        cell.loadCell(indexPath, dataModel: self.profileDataModel)
        cell.delegate = self
        cell.tag = indexPath.section
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "USER INFO"
        }
        else if section == 1{
            return "WEIGHT & HEIGHT"
        }
        else{
            return ""
        }
    }
    
}

//MARK: UITableViewDelegate Methods

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 || indexPath.row == 2 {
            self.configureActionSheet(forindex: indexPath)
        }
    }
}

//MARK: UITextFieldDelegates

extension ProfileViewController : UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 0 || textField.tag == 3 || textField.tag == 4{
            return true
        }
        else{
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0{
            self.profileDataModel.age = textField.text
        }
        else if textField.tag == 3{
            self.profileDataModel.weight = textField.text
        }
        else if textField.tag == 4{
            self.profileDataModel.height = textField.text
        }
    }
    
}

//MARK: UITableViewDelegate Methods

extension ProfileViewController:ProfileCustomCellDelegate {
    func didTappedActionButtonDelegateMethods(tag: Int) {
        if tag == 2 {
            //Read health kit data
            let profileData = healthManager.getProfileData()
            profileDataModel.age            = String(profileData.age)
            profileDataModel.biologicalSex  = String(profileData.bioSex)
            profileDataModel.bloodType      = String(profileData.bloodType)
            
            healthManager.getHeightData(successBlock: {(heightSample,heightString) -> Void in
                self.profileDataModel.height = heightString
                self.heightSampleVaue = heightSample
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [IndexPath.init(row: 1, section: 1)], with: UITableViewRowAnimation.none)
                    
                    self.updateBMI()

                }
                
            })
            healthManager.getWeightData(successBlock: {(weightSample,weightString) -> Void in
                self.profileDataModel.weight = weightString
                self.weightSampleValue = weightSample
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 1)], with: UITableViewRowAnimation.none)
                }
            })
            tableView.reloadData()
        }
        else if tag == 3 {
            saveHealthKitData()
        }
    }
}
