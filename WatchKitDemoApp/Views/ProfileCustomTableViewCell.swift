//
//  ProfileCustomTableViewCell.swift
//  WatchKitDemoApp
//
//  Created by dmi on 06/03/17.
//  Copyright © 2017 Siddharth suneel. All rights reserved.
//

import UIKit

protocol ProfileCustomCellDelegate {
    func didTappedActionButtonDelegateMethods(tag:Int)
}

class ProfileCustomTableViewCell: UITableViewCell  {
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var userTextField: UITextField!
    
    var delegate:ProfileCustomCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: Private Methods
    fileprivate func setup() {
        userTextField.delegate = self
        userTextField.returnKeyType = .done
    }
    
    //MARK: IBAction
    @IBAction func didTappedActionButton(_ sender: Any) {
        self.delegate?.didTappedActionButtonDelegateMethods(tag: self.tag)
    }
    
    //MARK: Public Methods
    func loadCell(_ indexPath :IndexPath, dataModel:ProfileDataModel){
        switch indexPath.section {
        case 0:
            self.actionButton.isHidden=true
            if indexPath.row == 0{
                self.userLabel.text = "Age"
                userTextField.keyboardType = .numberPad
                userTextField.tag=0
                userTextField.text = dataModel.age
            }
            else if indexPath.row == 1{
                self.userLabel.text = "Sex"
                userTextField.tag=1
                userTextField.text = dataModel.biologicalSex
            }
            else{
                self.userLabel.text = "Blood Type"
                userTextField.tag=2
                userTextField.text = dataModel.bloodType
            }
            break
        case 1:
            self.actionButton.isHidden=true
            
            if indexPath.row == 0{
                self.userLabel.text = "Weight"
                userTextField.tag=3
                userTextField.keyboardType = .numberPad
                userTextField.text = dataModel.weight
            }
            else if indexPath.row == 1{
                self.userLabel.text = "Height"
                userTextField.tag=4
                userTextField.keyboardType = .numberPad
                userTextField.text = dataModel.height
            }
            else{
                self.userLabel.text = "Body Mass Index"
                userTextField.tag=5
                userTextField.keyboardType = .numberPad
                userTextField.text = dataModel.BMI
            }
            break
            
        case 2:
            self.actionButton.isHidden=false
            self.actionButton.setTitle("Read HealthKit Data", for: .normal)
            self.actionButton.setTitleColor(UIColor.blue, for: .normal)
            self.userLabel.isHidden=true
            self.userTextField.isHidden=true
            userTextField.tag=6
            break
        case 3:
            self.actionButton.isHidden=false
            self.actionButton.setTitle("Save BMI", for: .normal)
            self.actionButton.setTitleColor(UIColor.red, for: .normal)
            self.userLabel.isHidden=true
            self.userTextField.isHidden=true
            userTextField.tag=7
            break
        default:
            break
            
        }
        
    }

}

extension ProfileCustomTableViewCell:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
