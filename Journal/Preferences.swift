//
//  Preferences.swift
//  Journal
//
//  Created by Kevin Hall on 6/13/18.
//  Copyright © 2018 Kevin Hall. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift
import BiometricAuthentication
import MessageUI
import UserNotifications

class Preferences: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    
    
    
    //let sectionTitles = ["","Icloud backup", "Design", "General"]
    let sectionTitles = ["","","","","",""]
    
    
    @IBOutlet weak var table: UITableView!
    
    @IBAction func scrollBack(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
        //NotificationCenter.default.post(name: .scrollFromSettings, object: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black

        NotificationCenter.default.addObserver(self, selector: #selector(themeChanged), name: .themeChanged, object: nil)

        table.backgroundColor = COLOR_BG
        table.clipsToBounds = true
        
        loadTheme()
    }

    
    
    

    
    @objc func themeChanged() {
        let cell = table.cellForRow(at: IndexPath(row: 0, section: 0))!

        let tableTitle = cell.viewWithTag(1) as! UILabel
        tableTitle.textColor = COLOR_TEXT
        tableTitle.backgroundColor = COLOR_BG
        let tableBackButton = cell.viewWithTag(2) as! UIButton
        tableBackButton.tintColor = COLOR_TEXT
        table.tableHeaderView?.backgroundColor = COLOR_TEXT.withAlphaComponent(0.1)
        self.view.backgroundColor = COLOR_BG
        
        let footerCell = table.cellForRow(at: IndexPath(row: 0, section: 5))!
        let footerTitle = footerCell.viewWithTag(3) as! UILabel
        footerTitle.textColor = COLOR_TEXT
        footerTitle.backgroundColor = COLOR_BG
        
        table.backgroundColor = COLOR_BG
        table.reloadData()
    }
    
    func loadTheme() {
        table.backgroundColor = COLOR_BG
        table.reloadData()
        
        let cell = table.cellForRow(at: IndexPath(row: 0, section: 0))!
        
        let tableTitle = cell.viewWithTag(1) as! UILabel
        tableTitle.textColor = COLOR_TEXT
        tableTitle.backgroundColor = COLOR_BG
        let tableBackButton = cell.viewWithTag(2) as! UIButton
        tableBackButton.tintColor = COLOR_TEXT
        table.tableHeaderView?.backgroundColor = COLOR_TEXT.withAlphaComponent(0.1)
        self.view.backgroundColor = COLOR_BG
        
        let footerCell = table.cellForRow(at: IndexPath(row: 0, section: 5))!
        let footerTitle = footerCell.viewWithTag(3) as! UILabel
        footerTitle.textColor = COLOR_TEXT
        footerTitle.backgroundColor = COLOR_BG
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = COLOR_TEXT.withAlphaComponent(0.1)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }else if section == 1 {
            return 1
        } else if section == 2 {
            return 2
        } else if section == 3 {
            return 3
        }else if section == 4 {
            return 2
        }else if section == 5 {
            return 1
        }
        
        return 0
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("hello again")
        var cell : UITableViewCell!
        
        
        
        if indexPath.section == 0{
            cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")! as UITableViewCell
            cell.backgroundColor = COLOR_BG
            
                        
        }else if indexPath.section == 1{
            cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
            cell.backgroundColor = COLOR_BG

            
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Sync"
                cell.textLabel?.textColor = COLOR_TEXT
                
                if let lastSyncDate = UserDefaults.standard.value(forKey: "last_sync") as? NSDate{
                    let dateFormatter = DateFormatter()
                    print(dateFormatter.timeSince(from: lastSyncDate, numericDates: true))
                    cell.detailTextLabel?.text = dateFormatter.timeSince(from: lastSyncDate, numericDates: true)
                } else {
                    cell.detailTextLabel?.text = "Never"
                }
            default:
                break
            }
            
        } else if indexPath.section == 2{
            cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
            cell.backgroundColor = COLOR_BG

            
            cell.textLabel?.textColor = COLOR_TEXT
            cell.detailTextLabel?.textColor = COLOR_TEXT.withAlphaComponent(0.5)
            
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Background"
                if UserDefaults.standard.color(forKey: "COLOR_BG") == UIColor.white {
                    cell.detailTextLabel?.text = "Light"
                } else {
                    cell.detailTextLabel?.text = "Dark"
                }
                cell.accessoryType = .disclosureIndicator
//            case 1:
//                cell.textLabel?.text = "Theme"
//
//                if let theme = UserDefaults.standard.value(forKey: "COLOR_THEME") as? String{
//                    cell.detailTextLabel?.text = theme
//                } else {
//                    cell.detailTextLabel?.text = ""
//                }
//
//                cell.accessoryType = .disclosureIndicator
            case 1:
                cell.textLabel?.text = "Feed dates"
                cell.detailTextLabel?.text = ""
                let switchView = UISwitch(frame: .zero)
                //switchView.onTintColor = UIColor.white
                
                if DATE_ON_CARD {
                    switchView.setOn(true, animated: false)
                } else {
                    switchView.setOn(false, animated: false)
                }
                
                switchView.tag = 10
                switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
                switchView.onTintColor = COLOR_TEXT.withAlphaComponent(0.5)
                cell.accessoryView = switchView
            default:
                break
            }
        } else if indexPath.section == 3{
            cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
            cell.backgroundColor = COLOR_BG
            cell.textLabel?.textColor = COLOR_TEXT
            cell.detailTextLabel?.textColor = COLOR_TEXT.withAlphaComponent(0.5)

            
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "View Info"
                cell.detailTextLabel?.text = ""
                cell.accessoryType = .disclosureIndicator
            case 1:
                cell.textLabel?.text = "Reminder"
                cell.detailTextLabel?.text = ""
                let switchView = UISwitch(frame: .zero)
                //switchView.onTintColor = UIColor.white
                
                if NOTIFICATIONS_ON {
                    switchView.setOn(true, animated: false)
                } else {
                    switchView.setOn(false, animated: false)
                }
                
                switchView.tag = 12
                switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
                switchView.onTintColor = COLOR_TEXT.withAlphaComponent(0.5)
                cell.accessoryView = switchView
            case 2:
                cell.textLabel?.text = "Passcode Lock"
                cell.detailTextLabel?.text = ""
                let switchView = UISwitch(frame: .zero)
                //switchView.onTintColor = UIColor.white
                
                if DATE_ON_CARD {
                    switchView.setOn(true, animated: false)
                } else {
                    switchView.setOn(false, animated: false)
                }
                
                switchView.tag = 10
                switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
                switchView.onTintColor = COLOR_TEXT.withAlphaComponent(0.5)
                cell.accessoryView = switchView
//            case 1:
//                cell.textLabel?.text = "FaceID"
//                cell.detailTextLabel?.text = ""
//
//                //here is programatically switch make to the table view
//                let switchView = UISwitch(frame: .zero)
//                switchView.onTintColor = COLOR_TEXT.withAlphaComponent(0.5)
//                switchView.setOn(false, animated: false)
//                switchView.tag = 11 // for detect which row switch Changed
//                switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
//                cell.accessoryView = switchView
//            case 1:
//                cell.textLabel?.text = "Reminder"
//                cell.detailTextLabel?.text = "Off"
//                cell.accessoryType = .disclosureIndicator
            default:
                break
            }
        }else if indexPath.section == 4{
            cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
            cell.backgroundColor = COLOR_BG
            cell.textLabel?.textColor = COLOR_TEXT
            cell.detailTextLabel?.textColor = COLOR_TEXT.withAlphaComponent(0.5)

            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Send Feedback"
                cell.detailTextLabel?.text = ""
                cell.accessoryType = .disclosureIndicator
            case 1:
                cell.textLabel?.text = "Rate"
                cell.detailTextLabel?.text = ""
                cell.accessoryType = .disclosureIndicator
            default:
                break
            }
        }else if indexPath.section == 5{
            cell = tableView.dequeueReusableCell(withIdentifier: "footerCell")! as UITableViewCell
            cell.backgroundColor = COLOR_BG
        }
        
        
        cell.selectionStyle = .none
        return cell
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
//        return 50
//    }
//    
//    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let view = UIImageView()
//        
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let detailVC = PreferencesDetail()
//        let transition = CATransition()
//        transition.duration = 0.3
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromRight
//        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
//        view.window!.layer.add(transition, forKey: kCATransition)
//        present(detailVC, animated: false, completion: nil)
        
        
        self.view.hideAllToasts()
        var style = ToastStyle()
        style.titleColor = COLOR_TEXT
        style.titleFont = UIFont(name: "Avenir-Black", size: 60)!
        style.messageColor = COLOR_TEXT
        style.messageFont = UIFont(name: "Avenir-Roman", size: 14)!
        style.backgroundColor = COLOR_TEXT.withAlphaComponent(0.05)
        style.cornerRadius = 5
        style.fadeDuration = 0.5
        style.messageAlignment = .center
        style.titleAlignment = .center
        style.horizontalPadding = 50
        
        // toast presented with multiple options and with a completion closure
        
        
        
        print(indexPath.section)
        print(indexPath.row)
        
        
        switch indexPath.section {
        case 2:
            if indexPath.row == 0 {
                if COLOR_BG == UIColor.white {
                    UserDefaults.standard.setColor(color: UIColor.black, forKey: "COLOR_BG")
                    UserDefaults.standard.setColor(color: UIColor.white, forKey: "COLOR_TEXT")
                    
                    COLOR_BG = UIColor.black
                    COLOR_TEXT = UIColor.white
                    statusbar = UIStatusBarStyle.lightContent
                    NotificationCenter.default.post(name: .themeChanged, object: nil)
                } else {
                    UserDefaults.standard.setColor(color: UIColor.white, forKey: "COLOR_BG")
                    UserDefaults.standard.setColor(color: UIColor.black, forKey: "COLOR_TEXT")
                    
                    COLOR_BG = UIColor.white
                    COLOR_TEXT = UIColor.black
                    statusbar = UIStatusBarStyle.default
                    NotificationCenter.default.post(name: .themeChanged, object: nil)
                }
            } else if indexPath.row == 1 {
                if let theme = UserDefaults.standard.value(forKey: "COLOR_THEME") as? String{
                    if theme == "PURPLE"{
                        UserDefaults.standard.setValue("PINK", forKey: "COLOR_THEME")
                        NotificationCenter.default.post(name: .themeChanged, object: nil)
                    }
                    if theme == "PINK"{
                        UserDefaults.standard.setValue("PURPLE", forKey: "COLOR_THEME")
                        NotificationCenter.default.post(name: .themeChanged, object: nil)
                    }
                }
            }
        case 3:
            if indexPath.row == 0 {
                self.performSegue(withIdentifier: "toOnboarding", sender: self)
            }
        case 4:
            if indexPath.row == 0 {
                if !MFMailComposeViewController.canSendMail() {
                    let alert = UIAlertController(title: "You dont have the email app.", message: "", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                sendEmail()
                
            } else if indexPath.row == 1 {
               openAppStore()
            }
        default: break
        }
        
       
        
        
        
        
        
        //performSegue(withIdentifier: "toDetail", sender: self)
    }
    
    
    func turnNotificationsOn() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                let center = UNUserNotificationCenter.current()
                
                let content = UNMutableNotificationContent()
                //content.title = "Write a journal"
                content.body = "Write in your journal."
                content.categoryIdentifier = "alarm"
                //content.userInfo = ["customData": "fizzbuzz"]
                content.sound = UNNotificationSound.default()
                
                var dateComponents = DateComponents()
                dateComponents.hour = 12
                dateComponents.minute = 0
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                center.add(request)
            } else {
            }
        }
    }
    
    func turnNotificationsOff() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    
    
    
    func openAppStore() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id1422860782"),
            UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:]) { (opened) in
                if(opened){
                    //                                print("App Store Opened")
                    //                                self.track()
                }
            }
        } else {
            print("Can't Open URL on Simulator")
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["mkevinhall@gmail.com"])
            mail.setMessageBody("<p>Hello Kevin, \n</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

    
    
    
    @objc func switchChanged(_ sender : UISwitch!){
        
        print("table row switch Changed \(sender.tag)")
        print("The switch is \(sender.isOn ? "ON" : "OFF")")
        
        // date on post
        if sender.tag == 10 {
            if sender.isOn {
                sender.setOn(false, animated: true)
                
                UserDefaults.standard.set(false, forKey: "DATE_ON_CARD")
                DATE_ON_CARD = false
                
                NotificationCenter.default.post(name: .reloadCoreData, object: nil)
            } else {
                sender.setOn(true, animated: true)
            
                UserDefaults.standard.set(true, forKey: "DATE_ON_CARD")
                DATE_ON_CARD = true
            
                NotificationCenter.default.post(name: .reloadCoreData, object: nil)
            }
        } else if sender.tag == 11{
//            BioMetricAuthenticator.authenticateWithBioMetrics(reason: "", success: {
//
//                // authentication successful
//
//            }, failure: { [weak self] (error) in
//
//                // do nothing on canceled
//                if error == .canceledByUser || error == .canceledBySystem {
//                    return
//                }
//
//                    // device does not support biometric (face id or touch id) authentication
//                else if error == .biometryNotAvailable {
//                    //self?.showErrorAlert(message: error.message())
//                }
//
//                    // show alternatives on fallback button clicked
//                else if error == .fallback {
//
//                    // here we're entering username and password
//                    //self?.txtUsername.becomeFirstResponder()
//                }
//
//                    // No biometry enrolled in this device, ask user to register fingerprint or face
//                else if error == .biometryNotEnrolled {
//                    //self?.showGotoSettingsAlert(message: error.message())
//                }
//
//                    // Biometry is locked out now, because there were too many failed attempts.
//                    // Need to enter device passcode to unlock.
//                else if error == .biometryLockedout {
//                    // show passcode authentication
//                }
//
//                    // show error on authentication failed
//                else {
//                    //self?.showErrorAlert(message: error.message())
//                }
//            })
        } else if sender.tag == 12 {
            if sender.isOn {
                sender.setOn(false, animated: true)

                UserDefaults.standard.set(false, forKey: "NOTIFICATIONS")
                NOTIFICATIONS_ON = false
                turnNotificationsOff()

                NotificationCenter.default.post(name: .reloadCoreData, object: nil)
            } else {
                sender.setOn(true, animated: true)

                UserDefaults.standard.set(true, forKey: "NOTIFICATIONS")
                NOTIFICATIONS_ON = true
                turnNotificationsOn()

                NotificationCenter.default.post(name: .reloadCoreData, object: nil)
            }
        }
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 0{
            return 100
        }else if indexPath.row == 0 && indexPath.section == 5{
            return 100
        } else {
            return 50
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusbar
    }
    
    
}



extension DateFormatter {
    /**
     Formats a date as the time since that date (e.g., “Last week, yesterday, etc.”).
     
     - Parameter from: The date to process.
     - Parameter numericDates: Determines if we should return a numeric variant, e.g. "1 month ago" vs. "Last month".
     
     - Returns: A string with formatted `date`.
     */
    func timeSince(from: NSDate, numericDates: Bool = false) -> String {
        let calendar = NSCalendar.current
        let now = NSDate()
        let earliest = now.earlierDate(from as Date)
        let latest = earliest == now as Date ? from : now
        let components = calendar.dateComponents([.year, .weekOfYear, .month, .day, .hour, .minute, .second], from: earliest, to: latest as Date)
        
        var result = ""
        
        if components.year! >= 2 {
            result = "\(components.year!) years ago"
        } else if components.year! >= 1 {
            if numericDates {
                result = "1 year ago"
            } else {
                result = "Last year"
            }
        } else if components.month! >= 2 {
            result = "\(components.month!) months ago"
        } else if components.month! >= 1 {
            if numericDates {
                result = "1 month ago"
            } else {
                result = "Last month"
            }
        } else if components.weekOfYear! >= 2 {
            result = "\(components.weekOfYear!) weeks ago"
        } else if components.weekOfYear! >= 1 {
            if numericDates {
                result = "1 week ago"
            } else {
                result = "Last week"
            }
        } else if components.day! >= 2 {
            result = "\(components.day!) days ago"
        } else if components.day! >= 1 {
            if numericDates {
                result = "1 day ago"
            } else {
                result = "Yesterday"
            }
        } else if components.hour! >= 2 {
            result = "\(components.hour!) hours ago"
        } else if components.hour! >= 1 {
            if numericDates {
                result = "1 hour ago"
            } else {
                result = "An hour ago"
            }
        } else if components.minute! >= 2 {
            result = "\(components.minute!) minutes ago"
        } else if components.minute! >= 1 {
            if numericDates {
                result = "1 minute ago"
            } else {
                result = "A minute ago"
            }
        } else if components.second! >= 3 {
            result = "\(components.second!) seconds ago"
        } else {
            result = "Just now"
        }
        
        return result
    }
}
