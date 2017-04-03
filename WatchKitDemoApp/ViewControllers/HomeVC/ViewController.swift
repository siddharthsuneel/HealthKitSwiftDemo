//
//  ViewController.swift
//  WatchKitDemoApp
//
//  Created by Siddharth suneel on 01/03/17.
//  Copyright © 2017 Siddharth suneel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let healthManager:HealthManager = HealthManager()
    
    var dataSourceArray:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        healthManager.authoriseHealthKit()
    }
    
    fileprivate func setup() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        createDataSource()
    }
    
    fileprivate func createDataSource() {
        dataSourceArray = ["Activity", "Nutrition", "Relax", "Sleep", "Me"]
    }

}

    //MARK: UITableViewDataSource Methods

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count
    }
    
    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = {
            guard let cell1 = tableView.dequeueReusableCell(withIdentifier: Constants.tableViewCellID) else {
                return UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: Constants.tableViewCellID)
            }
            return cell1
        }()
        cell.selectionStyle = .none
        cell.textLabel?.text = (dataSourceArray.object(at: indexPath.row) as! String)
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }
}

    //MARK: UITableViewDelegate Methods

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var pushToVC:UIViewController?
        switch indexPath.row {
        case 0:
            if let configurationViewController = storyboard?.instantiateViewController(withIdentifier: "ConfigurationViewController") as? ConfigurationViewController {
                self.navigationController?.pushViewController(configurationViewController, animated: true)
            }
            break
        case 1:
            break
        case 2:
            break
        case 3:
            break
        case 4:
            pushToVC = ProfileViewController()
            break
        default:
            break
        }
        
        if pushToVC != nil {
            self.navigationController?.pushViewController(pushToVC!, animated: true)
        }
    }
}
