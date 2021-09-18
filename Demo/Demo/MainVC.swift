//
//  ViewController.swift
//  Demo
//
//  Created by hwreal on 2021/9/16.
//

import UIKit

enum DemoType: String, CaseIterable {
    case FastNotification
    case AlertStyleView
    
    var vcType: UIViewController.Type{
        switch self {
        case .FastNotification:
            return FastNotificationProtocolVC.self
        case .AlertStyleView:
            return AlertStyleViewVC.self
        }
    }
}

class MainVC: UITableViewController {
    
    let titles: [DemoType] = [
        .FastNotification,
        .AlertStyleView
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "HWUtils"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
    }
}


extension MainVC{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath)
        cell.textLabel?.text = titles[indexPath.row].rawValue
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vcType = titles[indexPath.row].vcType
        let vc = vcType.init()
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
