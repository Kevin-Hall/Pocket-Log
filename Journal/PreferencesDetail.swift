//
//  PreferencesDetail.swift
//  Journal
//
//  Created by Kevin Hall on 6/19/18.
//  Copyright © 2018 Kevin Hall. All rights reserved.
//

import Foundation
import UIKit


class PreferencesDetail: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var table: UITableView!
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("<", for: .normal)
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        button.setTitleColor(COLOR_TEXT, for: .normal)
        button.backgroundColor = COLOR_BG
        button.titleLabel?.font  = UIFont(name: "Avenir-Roman", size: 12)
        return button
    }()
    
    
    override func viewWillLayoutSubviews() {
        cancelButton.frame = CGRect(x: 30, y: 50, width: 60, height: 60)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        
        
        self.view.addSubview(cancelButton)
        
        
        table = UITableView(frame: self.view.bounds)
        
        table.backgroundColor = UIColor.black
        table.clipsToBounds = true
        table.layer.cornerRadius = 10
        table.tableHeaderView?.backgroundColor = UIColor.gray
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 3
        } else if section == 3 {
            return 3
        }
        
        return 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell!
        
        cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell

        
//        if indexPath.section == 0 {
//            cell = tableView.dequeueReusableCell(withIdentifier: "proCell")! as UITableViewCell
//        } else if indexPath.section == 1{
//            cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
//
//            switch indexPath.row {
//            case 0:
//                cell.textLabel?.text = "Sync"
//                cell.detailTextLabel?.text = "1 minute ago"
//            default:
//                break
//            }
//
//        } else if indexPath.section == 2{
//            cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
//
//            switch indexPath.row {
//            case 0:
//                cell.textLabel?.text = "Theme"
//                cell.detailTextLabel?.text = ""
//                cell.accessoryType = .disclosureIndicator
//            case 1:
//                cell.textLabel?.text = "Font Size"
//                cell.detailTextLabel?.text = "12"
//                cell.accessoryType = .disclosureIndicator
//            case 2:
//                cell.textLabel?.text = "Date on Post"
//                cell.detailTextLabel?.text = "OFF"
//                cell.accessoryType = .disclosureIndicator
//            default:
//                break
//            }
//        } else if indexPath.section == 3{
//            cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
//
//            switch indexPath.row {
//            case 0:
//                cell.textLabel?.text = "Support"
//                cell.detailTextLabel?.text = ""
//                cell.accessoryType = .disclosureIndicator
//            case 1:
//                cell.textLabel?.text = "FaceID"
//                cell.detailTextLabel?.text = ""
//
//                //here is programatically switch make to the table view
//                let switchView = UISwitch(frame: .zero)
//                switchView.onTintColor = UIColor.white
//                switchView.setOn(false, animated: true)
//                switchView.tag = indexPath.row // for detect which row switch Changed
//                switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
//                cell.accessoryView = switchView
//            case 2:
//                cell.textLabel?.text = "Reminder"
//                cell.detailTextLabel?.text = "OFF"
//                cell.accessoryType = .disclosureIndicator
//            default:
//                break
//            }
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let detailVC =
//        let transition = CATransition()
//        transition.duration = 0.5
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromRight
//        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
//        view.window!.layer.add(transition, forKey: kCATransition)
//        present(dashboardWorkout, animated: false, completion: nil)
        //performSegue(withIdentifier: "toDetail", sender: self)
    }
    
    @objc func switchChanged(_ sender : UISwitch!){
        
        print("table row switch Changed \(sender.tag)")
        print("The switch is \(sender.isOn ? "ON" : "OFF")")
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 0{
            return 122
        } else {
            return 50
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    @objc func dismissVC() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false)
        
        if COLOR_BG == UIColor.white {
            COLOR_BG = UIColor.black
            COLOR_TEXT = UIColor.white
            statusbar = .lightContent
        } else {
            COLOR_BG = UIColor.white
            COLOR_TEXT = UIColor.black
            statusbar = .default
        }
    }
}
