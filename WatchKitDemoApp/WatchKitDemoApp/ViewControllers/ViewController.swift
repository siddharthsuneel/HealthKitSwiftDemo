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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = {
            guard let cell1 = tableView.dequeueReusableCell(withIdentifier: Constants.tableViewCellIdentifier) else {
                return UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: Constants.tableViewCellIdentifier)
            }
            return cell1
        }()
        cell.selectionStyle = .none
        cell.textLabel?.text = "Hello : \(indexPath.row)"
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
