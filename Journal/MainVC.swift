//
//  MainVC.swift
//  Journal
//
//  Created by Kevin Hall on 4/2/17.
//  Copyright © 2017 Kevin Hall. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import FSCalendar
import MessageUI



var bgColor = UIColor(rgb: 0xffffff)
var separatorColor = UIColor(rgb: 0xDCE2E6)
var textColor = UIColor(red: 41/255, green: 41/255, blue: 48/255, alpha: 1)
var dateColor = UIColor(rgb: 0x53C8F9).withAlphaComponent(0.5)
var todayDateColor = UIColor(rgb: 0x53C8F9)
var fontSize: CGFloat = CGFloat(UserDefaults.standard.integer(forKey: "fontSize")) //the fontsize of the tableview



class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let formatter = DateFormatter() //used to set the date of each cell
    let dateFindingformatter = DateFormatter() //used to set the date of each cell
    let imagePicker = UIImagePickerController()
    var scrollToTop : UIButton? //button to scroll to top of tableview
    var isRight = Bool() //to determine if the tableview is off to the side
    var entries: [NSManagedObject] = [] //core data
    var calendar = FSCalendar(frame: CGRect(x: -248, y: 50, width: 250, height: 300)) //sidemenu calendar declaration
    
    //sidemenu button declarations
    var themeButton = UIButton(frame: CGRect(x: -235, y: 450, width: 230, height: 30))
    var fontButtonPlus = UIButton(frame: CGRect(x: -235, y: 490, width: 230, height: 30))
    var fontButtonMinus = UIButton(frame: CGRect(x: -235, y: 530, width: 230, height: 30))
    var shareButton = UIButton(frame: CGRect(x: -235, y: 570, width: 230, height: 30))
    var contactButton = UIButton(frame: CGRect(x: -235, y: 610, width: 230, height: 30))
    
    //used to set the font of each date label in the table cells
    let dateFont = UIFont(name: "Avenir-Heavy", size: CGFloat(20))

    //mask layer to make rounded corners
    let maskLayer = CAShapeLayer()
    var path = UIBezierPath()


    // will appear did load ---------------------------------------------------------------------------------------------------------------
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        //print("view will appear")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()

        
        if calendar.frame.minX > 0 {
            moveLeft()
        }
        
        //initially the tableview is not set right
        isRight = false
        
        let fontPlus = "FONT +"
        let fp = NSMutableAttributedString(
            string: fontPlus,
            attributes: [NSFontAttributeName:UIFont(
                name: "Open Sans",
                size: 12)!,NSForegroundColorAttributeName:textColor])
        
        let fontMinus = "FONT -"
        let fm = NSMutableAttributedString(
            string: fontMinus,
            attributes: [NSFontAttributeName:UIFont(
                name: "Open Sans",
                size: 12)!,NSForegroundColorAttributeName:textColor])
        
        let theme = "THEME"
        let t = NSMutableAttributedString(
            string: theme,
            attributes: [NSFontAttributeName:UIFont(
                name: "Open Sans",
                size: 12)!,NSForegroundColorAttributeName:textColor])
        
        let share = "SHARE"
        let s = NSMutableAttributedString(
            string: share,
            attributes: [NSFontAttributeName:UIFont(
                name: "Open Sans",
                size: 12)!,NSForegroundColorAttributeName:textColor])
        
        let contact = "CONTACT"
        let c = NSMutableAttributedString(
            string: contact,
            attributes: [NSFontAttributeName:UIFont(
                name: "Open Sans",
                size: 12)!,NSForegroundColorAttributeName:textColor])
        
        self.view.addSubview(themeButton)
        themeButton.addTarget(self, action: #selector(changeTheme), for: .touchUpInside)
        themeButton.setAttributedTitle(t, for: .normal)
        themeButton.backgroundColor = textColor.withAlphaComponent(0.1)
        themeButton.layer.cornerRadius = 5
        
        self.view.addSubview(fontButtonPlus)
        fontButtonPlus.addTarget(self, action: #selector(changeFontPlus), for: .touchUpInside)
        fontButtonPlus.setAttributedTitle(fp, for: .normal)
        fontButtonPlus.backgroundColor = textColor.withAlphaComponent(0.1)
        fontButtonPlus.layer.cornerRadius = 5
        
        self.view.addSubview(fontButtonMinus)
        fontButtonMinus.addTarget(self, action: #selector(changeFontMinus), for: .touchUpInside)
        fontButtonMinus.setAttributedTitle(fm, for: .normal)
        fontButtonMinus.backgroundColor = textColor.withAlphaComponent(0.1)
        fontButtonMinus.layer.cornerRadius = 5
        
        self.view.addSubview(shareButton)
        shareButton.addTarget(self, action: #selector(share(sender:)), for: .touchUpInside)
        shareButton.setAttributedTitle(s, for: .normal)
        shareButton.backgroundColor = textColor.withAlphaComponent(0.1)
        shareButton.layer.cornerRadius = 5
        
        self.view.addSubview(contactButton)
        contactButton.addTarget(self, action: #selector(contactAction), for: .touchUpInside)
        contactButton.setAttributedTitle(c, for: .normal)
        contactButton.backgroundColor = textColor.withAlphaComponent(0.1)
        contactButton.layer.cornerRadius = 5
        
        
        //core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entries")
        
        do {
            entries = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        formatter.dateFormat = "MMMM d"
        dateFindingformatter.dateFormat = "MMMM d, YYYY"
        
        //on initial run add an empty entry
        if entries.count == 0 {
            print("entries was empty")
            save(date: Date(), content: "Welcome to your new Journal, in the words of Ernest Hemingway \"my aim is to put down on paper what I see and what I feel in the best and simplest way\" However instead of paper this is the modern day version! \n\n\nEveryday the top of this page will be where you write your entry, once the next day comes you will not be able to edit the past entry and a new entry will be appear at the top for you to write in! \n\n\nTo edit the settings of this app and access a calendar swipe right. You can swipe up and down on the calendar and tap a date to scroll to the entry from that day. To delete this entry and Start journaling swipe left on it. request a feature or tell me about a bug!", image: UIImage())
            save(date: Date(), content: "", image: UIImage())
        } else {
            let firstEntry = entries[entries.count-1]
            let firstDate = firstEntry.value(forKey: "date") as! Date?
            let firstContent = firstEntry.value(forKey: "content") as! String?
            
            if formatter.string(from: firstDate!) != formatter.string(from: Date()) && firstContent != ""{
                save(date: Date(), content: "", image: UIImage())
            }
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        view.backgroundColor = bgColor
    
        scrollToTop = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        scrollToTop?.backgroundColor = bgColor
        scrollToTop?.setTitle("↑", for: .normal)
        scrollToTop?.setTitleColor(textColor, for: .normal)
        scrollToTop?.addTarget(self, action: #selector(scrollToTopAction), for: .touchUpInside)
        
        //set the mask
        path = UIBezierPath(roundedRect:self.view.bounds,byRoundingCorners:[.allCorners],cornerRadii: CGSize(width: 30 ,height: 250))
        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.path = path.cgPath
        
        //view looks
        self.view.layer.mask = maskLayer
        tableView.backgroundColor = bgColor
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 65))
        tableView.separatorColor = separatorColor
        tableView.separatorInset = UIEdgeInsetsMake(0, 17, 0, 17)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(updateTable), name: NSNotification.Name(rawValue: "didBecomeActive"), object: nil)
        nc.addObserver(self, selector: #selector(saveData), name: NSNotification.Name(rawValue: "willClose"), object: nil)

        
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = true
        calendar.clipsToBounds = true
        
        //appearance
        self.calendar.allowsMultipleSelection = false
        self.calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        self.calendar.swipeToChooseGesture.isEnabled = true
        self.calendar.appearance.caseOptions = [.weekdayUsesSingleUpperCase]
        self.calendar.appearance.headerTitleFont = UIFont(name: "Avenir-Heavy", size: CGFloat(20))
        self.calendar.appearance.titleFont = UIFont(name: "Open Sans", size: 10)!
        self.calendar.headerHeight = 50
        self.calendar.weekdayHeight = 50
        self.calendar.appearance.headerTitleColor = textColor.withAlphaComponent(0.5)
        self.calendar.appearance.selectionColor = todayDateColor.withAlphaComponent(0.5)
        self.calendar.appearance.selectionColor = bgColor
        self.calendar.appearance.titleSelectionColor = todayDateColor
        self.calendar.calendarHeaderView.tintColor = todayDateColor
        self.calendar.appearance.weekdayTextColor = todayDateColor
        self.calendar.appearance.weekdayFont = UIFont(name: "Open Sans", size: 12)!
        self.calendar.appearance.todaySelectionColor = bgColor
        self.calendar.appearance.todayColor = todayDateColor
        self.calendar.appearance.titleTodayColor = todayDateColor
        self.calendar.appearance.titleTodayColor = bgColor
        self.calendar.appearance.titleDefaultColor = textColor
        self.calendar.appearance.eventSelectionColor = textColor
        self.calendar.appearance.borderSelectionColor = textColor
        self.calendar.appearance.borderRadius = 0.2
        self.calendar.scrollDirection = .vertical
        
        view.addSubview(calendar)
        
        
        

        
        //save(date: Date().addingTimeInterval(60*60*24*2), content: "What really made me mad was the note that Sarah slipped into my locker during passing period. She said she was sad that I’ve been hanging out with Jane more lately and thinks that I don’t want to be her friend anymore. I can’t believe she thinks that, especially after talking with her on the phone for hours and hours last month while she was going through her breakup with Nick! Just because I’ve been hanging out with Jane a little more than usual doesn’t mean I’m not her friend anymore. She completely blew me off at lunch, and when I told Jane, she thought that Sarah was being a “drama queen.", image: UIImage(named: "a")!)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! EditorVC
        
        let entry = entries[entries.count-1-(tableView.indexPathForSelectedRow?.row)!]
        let image = entry.value(forKey: "image") as! UIImage?
        
        vc.image = image!
        self.tableView.deselectRow(at: (tableView.indexPathForSelectedRow)!, animated: false)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            //set the mask
            self.path = UIBezierPath(roundedRect:self.view.bounds,byRoundingCorners:[.allCorners],cornerRadii: CGSize(width: 30 ,height: 250))
            self.maskLayer.fillColor = UIColor.black.cgColor
            self.maskLayer.path = self.path.cgPath
            self.scrollToTop?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
        };
    }

    /*
     side menu button functions
     -----------------------------------------------------------------------------------------------------------------------
     */
    func changeFontPlus() {
        if fontSize < 20 {
            fontSize += 1
            UserDefaults.standard.set(fontSize, forKey: "fontSize")

        }
        tableView.reloadData()
    }
    
    func changeFontMinus() {
        if fontSize > 5 {
            fontSize -= 1
            UserDefaults.standard.set(fontSize, forKey: "fontSize")
        }
        tableView.reloadData()
    }
    
    func contactAction() {
        
        if !MFMailComposeViewController.canSendMail() {
            let alert = UIAlertController(title: "You dont have the email app.", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        sendEmail()
    }
    
    
    func changeTheme() {
        if textColor == UIColor.white {
            bgColor = UIColor.white
            separatorColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 0.26)
            textColor = UIColor(red: 41/255, green: 41/255, blue: 48/255, alpha: 1)
            dateColor = UIColor(rgb: 0x53C8F9).withAlphaComponent(0.5)
            todayDateColor = UIColor(rgb: 0x53C8F9)
            self.view.backgroundColor = bgColor
            tableView.tableHeaderView?.backgroundColor = bgColor
            tableView.backgroundColor = bgColor
            tableView.separatorColor = separatorColor
            scrollToTop?.backgroundColor = bgColor
            scrollToTop?.setTitleColor(textColor, for: .normal)
            themeButton.setTitleColor(textColor, for: .normal)
            fontButtonMinus.setTitleColor(textColor, for: .normal)
            fontButtonPlus.setTitleColor(textColor, for: .normal)
            fontButtonMinus.backgroundColor = UIColor(red: 41/255, green: 41/255, blue: 48/255, alpha: 1)
            
            UserDefaults.standard.set("no", forKey: "darkMode")

        } else if textColor == UIColor(red: 41/255, green: 41/255, blue: 48/255, alpha: 1){
            //dark mode
            bgColor = UIColor(red: 41/255, green: 41/255, blue: 48/255, alpha: 1)
            separatorColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 0.26)
            textColor = UIColor.white
            dateColor = UIColor(rgb: 0x53C8F9).withAlphaComponent(0.5)
            todayDateColor = UIColor(rgb: 0x53C8F9)
            self.view.backgroundColor = bgColor
            tableView.tableHeaderView?.backgroundColor = bgColor
            tableView.backgroundColor = bgColor
            tableView.separatorColor = separatorColor
            scrollToTop?.backgroundColor = bgColor
            scrollToTop?.setTitleColor(textColor, for: .normal)
            
            UserDefaults.standard.set("yes", forKey: "darkMode")
        }
        
        updateCalColors()
        
        
        let fontPlus = "FONT +"
        let fp = NSMutableAttributedString(
            string: fontPlus,
            attributes: [NSFontAttributeName:UIFont(
                name: "Open Sans",
                size: 12)!,NSForegroundColorAttributeName:textColor])
        
        let fontMinus = "FONT -"
        let fm = NSMutableAttributedString(
            string: fontMinus,
            attributes: [NSFontAttributeName:UIFont(
                name: "Open Sans",
                size: 12)!,NSForegroundColorAttributeName:textColor])
        
        let theme = "THEME"
        let t = NSMutableAttributedString(
            string: theme,
            attributes: [NSFontAttributeName:UIFont(
                name: "Open Sans",
                size: 12)!,NSForegroundColorAttributeName:textColor])
        
        let share = "SHARE"
        let s = NSMutableAttributedString(
            string: share,
            attributes: [NSFontAttributeName:UIFont(
                name: "Open Sans",
                size: 12)!,NSForegroundColorAttributeName:textColor])
        
        let contact = "CONTACT"
        let c = NSMutableAttributedString(
            string: contact,
            attributes: [NSFontAttributeName:UIFont(
                name: "Open Sans",
                size: 12)!,NSForegroundColorAttributeName:textColor])
    
    
        themeButton.setAttributedTitle(t, for: .normal)
        fontButtonPlus.setAttributedTitle(fp, for: .normal)
        fontButtonMinus.setAttributedTitle(fm, for: .normal)
        shareButton.setAttributedTitle(s, for: .normal)
        contactButton.setAttributedTitle(c, for: .normal)

        
        tableView.reloadData()
    }
    
    func updateCalColors() {
        //appearance
        self.calendar.appearance.headerTitleColor = textColor.withAlphaComponent(0.5)
        self.calendar.appearance.selectionColor = todayDateColor.withAlphaComponent(0.5)
        self.calendar.appearance.selectionColor = bgColor
        self.calendar.appearance.titleSelectionColor = todayDateColor
        self.calendar.calendarHeaderView.tintColor = todayDateColor
        self.calendar.appearance.weekdayTextColor = todayDateColor
        self.calendar.appearance.weekdayFont = UIFont(name: "Open Sans", size: 11)!
        self.calendar.appearance.todaySelectionColor = bgColor
        self.calendar.appearance.titleTodayColor = bgColor
        self.calendar.appearance.todayColor = todayDateColor
        self.calendar.appearance.titleDefaultColor = textColor
        self.calendar.appearance.eventSelectionColor = textColor
        self.calendar.appearance.borderSelectionColor = textColor
        
        
        themeButton.backgroundColor = textColor.withAlphaComponent(0.1)
        fontButtonPlus.backgroundColor = textColor.withAlphaComponent(0.1)
        fontButtonMinus.backgroundColor = textColor.withAlphaComponent(0.1)
        shareButton.backgroundColor = textColor.withAlphaComponent(0.1)
        contactButton.backgroundColor = textColor.withAlphaComponent(0.1)

    }
    
    //handles gestures
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                moveRight()
                print("right")
            case UISwipeGestureRecognizerDirection.left:
                moveLeft()
                print("left")
            default:
                break
            }
        }
    }
    
    //moves the view to the right
    func moveRight() {
        if !isRight{
            self.isRight = true
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 9, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.tableView.transform.tx += 250
                self.themeButton.transform.tx += 250
                self.fontButtonPlus.transform.tx += 250
                self.fontButtonMinus.transform.tx += 250
                self.calendar.transform.tx += 250
                self.shareButton.transform.tx += 250
                self.contactButton.transform.tx += 250

                
            }) { _ in
            }
        }
    }
    
    //moves the view to the left
    func moveLeft() {
        if isRight{
            self.isRight = false
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 9, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.tableView.transform.tx -= 250
                self.themeButton.transform.tx -= 250
                self.fontButtonPlus.transform.tx -= 250
                self.fontButtonMinus.transform.tx -= 250
                self.calendar.transform.tx -= 250
                self.shareButton.transform.tx -= 250
                self.contactButton.transform.tx -= 250


            }) { _ in
            }
        }
    }
    
    func share(sender:UIView){
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        //let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let textToShare = "Check out this Journal app"
        
        if let myWebsite = URL(string: "http://itunes.apple.com/app/id1224797713") {
            let objectsToShare = [textToShare, myWebsite/*, image ?? #imageLiteral(resourceName: "app-logo")*/] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //Excluded Activities
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            //
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: { () in
                // this is where the completion handler code goes
                self.isRight = true
                print("rhity")
            })
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

    /*
    Table View methods
    -----------------------------------------------------------------------------------------------------------------------
    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tvFont = UIFont(name: "Open Sans", size: CGFloat(fontSize))
        let entry = entries[entries.count-1-indexPath.row]
        
        if indexPath.row == 0 {
            
            if (entry.value(forKey: "image") as! UIImage?)?.size == CGSize(width: 0, height: 0){
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
                
                let dateLabel = cell.viewWithTag(1) as! UILabel
                let tv = cell.viewWithTag(2) as! UITextView
                tv.tintColor = todayDateColor
                tv.delegate = self
                
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                

                
                dateLabel.text = "TODAY"

                dateLabel.textColor = todayDateColor
                tv.textContainerInset = UIEdgeInsetsMake(0, -4, 5, 10)
                tv.backgroundColor = bgColor
                tv.textColor = textColor
                tv.isEditable = true
                dateLabel.font = UIFont(name: "Avenir-Heavy", size: CGFloat(20))
                dateLabel.clipsToBounds = false
                dateLabel.sizeToFit()
                tv.font = tvFont
                cell.backgroundColor = bgColor
                tv.text = entry.value(forKey: "content") as! String?
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellImage")! as UITableViewCell
                
                let dateLabel = cell.viewWithTag(1) as! UILabel
                let tv = cell.viewWithTag(2) as! UITextView
                let imageView = cell.viewWithTag(3) as! UIImageView
                
                imageView.layer.cornerRadius = 5
                imageView.image = entry.value(forKey: "image") as! UIImage?
                
                tv.tintColor = todayDateColor
                tv.delegate = self
                
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                
                dateLabel.text = "TODAY"
                dateLabel.textColor = todayDateColor
                tv.textContainerInset = UIEdgeInsetsMake(0, -4, 5, 10)
                tv.backgroundColor = bgColor
                tv.textColor = textColor
                tv.isEditable = true
                dateLabel.font = UIFont(name: "Avenir-Heavy", size: CGFloat(20))
                dateLabel.sizeToFit()
                dateLabel.clipsToBounds = false
                tv.font = tvFont
                
                cell.backgroundColor = bgColor
                tv.text = entry.value(forKey: "content") as! String?
                
                return cell
                
            }
            
        } else  {
            
            if (entry.value(forKey: "image") as! UIImage?)?.size == CGSize(width: 0, height: 0){
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
                
                let dateLabel = cell.viewWithTag(1) as! UILabel
                let tv = cell.viewWithTag(2) as! UITextView
                
                
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                
                dateLabel.text = formatter.string(from: (entry.value(forKey: "date") as! Date?)!)
                tv.textContainerInset = UIEdgeInsetsMake(0, -4, 5, 10)
                tv.backgroundColor = bgColor
                tv.textColor = textColor
                tv.tintColor = todayDateColor
                cell.backgroundColor = bgColor
                dateLabel.textColor = dateColor
                dateLabel.font = dateFont
                
                tv.isEditable = false
                tv.font = tvFont
                tv.text = entry.value(forKey: "content") as! String?
                
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellImage")! as UITableViewCell
                
                let dateLabel = cell.viewWithTag(1) as! UILabel
                let tv = cell.viewWithTag(2) as! UITextView
                
                let imageView = cell.viewWithTag(3) as! UIImageView
                
                
                imageView.layer.cornerRadius = 5
                imageView.image = entry.value(forKey: "image") as! UIImage?
                
                //cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.selectedBackgroundView = UIView()
                
                dateLabel.text = formatter.string(from: (entry.value(forKey: "date") as! Date?)!)
                tv.textContainerInset = UIEdgeInsetsMake(0, -4, 5, 10)
                tv.backgroundColor = bgColor
                tv.textColor = textColor
                tv.tintColor = todayDateColor
                cell.backgroundColor = bgColor
                dateLabel.textColor = dateColor
                dateLabel.font = dateFont
                
                
                tv.isEditable = false
                tv.font = tvFont
                tv.text = entry.value(forKey: "content") as! String?
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row != 0 && !isRight {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            // remove the deleted item from the model
            let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let context:NSManagedObjectContext = appDel.managedObjectContext
            context.delete(entries[self.entries.count - 1 - indexPath.row])
            entries.remove(at: self.entries.count - 1 - indexPath.row)
            
            do {
                try context.save()
            } catch _ {
            }
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
            //let date = cell?.viewWithTag(1) as! UILabel
            
            if cell?.viewWithTag(3) != nil && !isRight {
                self.performSegue(withIdentifier: "toEditor", sender: self)
            }

            
            let tv = cell?.viewWithTag(2) as! UITextView
            
            if isRight {
                moveLeft()
                isRight = false
            }
            tv.becomeFirstResponder()
            
        } else {
            scrollToSelectedRow()
            let cell = tableView.cellForRow(at: indexPath)
            
            if cell?.viewWithTag(3) != nil && !isRight {
                self.performSegue(withIdentifier: "toEditor", sender: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: "   DELETE   ") { (rowAction, indexPath) in
            //TODO: Delete the row at indexPath here
            // remove the deleted item from the model
            let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let context:NSManagedObjectContext = appDel.managedObjectContext
            context.delete(self.entries[self.entries.count - 1 - indexPath.row])
            self.entries.remove(at: self.entries.count - 1 - indexPath.row)
            
            do {
                try context.save()
            } catch _ {
            }
            tableView.reloadData()
        }
        deleteAction.backgroundColor = todayDateColor
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row < 7 && (self.scrollToTop?.isDescendant(of: self.view))!{
            removeScrollToTop()
            
            
        }else if indexPath.row < 7 && indexPath.row > 1{
            
            

            self.tableView.endEditing(true)
        
        } else if !(self.scrollToTop?.isDescendant(of: self.view))! && indexPath.row > 7{
            addScrollToTop()
        }
        
        

        
        //SystemSoundID.playFileNamed(fileName: "ss", withExtenstion: "wav")
    }
    
    func addScrollToTop() {
        self.scrollToTop?.alpha = 0
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.view.addSubview(self.scrollToTop!)
            self.scrollToTop?.alpha = 1
        }) { _ in
        }
    }
    
    func removeScrollToTop() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.scrollToTop?.alpha = 0
        }) { _ in
            self.scrollToTop?.removeFromSuperview()
        }
    }
    
    func scrollToTopAction() {
        tableView.setContentOffset(CGPoint.zero, animated: true)
    }

    //called when the app reopens
    func updateTable() {
        let firstEntry = entries[entries.count-1]
        let firstDate = firstEntry.value(forKey: "date") as! Date?
        let firstContent = firstEntry.value(forKey: "content") as! String?
        
        
        if formatter.string(from: firstDate!) != formatter.string(from: Date()) && firstContent != ""{
            save(date: Date(), content: "", image: UIImage())
        }
        tableView.reloadData()
    }
    
    func scrollToSelectedRow() {
        let selectedRows = self.tableView.indexPathsForSelectedRows
        if let selectedRow = selectedRows?[0] {
            self.tableView.scrollToRow(at: selectedRow, at: .middle, animated: true)
        }
    }
    
    func scrollToSelectedDate() {
        
        let dateToFind = calendar.selectedDate
        
        for row in 0..<tableView.numberOfRows(inSection: 0) {
            let entry = entries[entries.count-1-row]
            let cellDate = entry.value(forKey: "date") as! Date?
            
            if dateFindingformatter.string(from: cellDate!) == dateFindingformatter.string(from: dateToFind) {
                self.tableView.scrollToRow(at: IndexPath(row: row, section: 0), at: .middle, animated: true)
            }
            
        }
    }
    
    //update right before closing
    func saveData(){
        
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        let tv = cell?.viewWithTag(2) as! UITextView
        updateData(tv.text, newDate: Date(),index: 0)
        print("saved the data")
    }

    
    /*
    Text View methods
    -----------------------------------------------------------------------------------------------------------------------
    */

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if isRight {
        return false
        }
        
        //toolbar stuff
        let dateToolBar: UIToolbar = UIToolbar(frame: CGRect(x:0, y:0, width:320,height: 40))
        dateToolBar.setBackgroundImage(UIImage(),
                                        forToolbarPosition: .any,
                                        barMetrics: .default)
        dateToolBar.setShadowImage(UIImage(), forToolbarPosition: .any)
        dateToolBar.backgroundColor = textColor.withAlphaComponent(0.9)
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let add: UIBarButtonItem = UIBarButtonItem(title: "Add Image", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.addImage))
        add.setTitleTextAttributes([NSForegroundColorAttributeName: bgColor,NSFontAttributeName: UIFont(name: "Open Sans", size: 14)!], for: .normal)
        
        let remove: UIBarButtonItem = UIBarButtonItem(title: "Remove Image", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.removeImage))
        remove.setTitleTextAttributes([NSForegroundColorAttributeName: bgColor,NSFontAttributeName: UIFont(name: "Open Sans", size: 14)!], for: .normal)

        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.done))
        done.setTitleTextAttributes([NSForegroundColorAttributeName: bgColor,NSFontAttributeName: UIFont(name: "Open Sans", size: 14)!], for: .normal)
        
        dateToolBar.tintColor = UIColor.white
        
        let entry = entries[entries.count-1]
        if (entry.value(forKey: "image") as! UIImage?)?.size == CGSize(width: 0, height: 0){
            dateToolBar.items = [add,flexSpace,done]
        } else {
            dateToolBar.items = [remove,flexSpace,done]
        }
        dateToolBar.sizeToFit()
        
        //instead of keyboar open date picker
        textView.inputAccessoryView = dateToolBar
        return true
    }
    
    func done() {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        let tv = cell?.viewWithTag(2) as! UITextView
        updateData(tv.text, newDate: Date(),index: 0)
        self.view.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n" {
//            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
//            let tv = cell?.viewWithTag(2) as! UITextView
//            updateData(tv.text, newDate: Date(),index: 0)
//            self.view.endEditing(true)
//            return false
//        }
        return true
    }
    
    
    /*
     Cal methods
     -----------------------------------------------------------------------------------------------------------------------
     */
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        print("selected" + date.description)
        
        scrollToSelectedDate()
        
    }
    /*
    image pick / toolbar actions
    -----------------------------------------------------------------------------------------------------------------------
    */
    func addImage() {
        //first save the text
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        let tv = cell?.viewWithTag(2) as! UITextView
        updateData(tv.text, newDate: Date(),index: 0)
        
        //then open the image picker
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }

    func removeImage() {
       updateImage(image: UIImage())
        tableView.reloadData()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
           updateImage(image: image)
            tableView.reloadData()
        } else{
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    Core data
    -----------------------------------------------------------------------------------------------------------------------
    */
    func save(date: Date, content: String, image: UIImage) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "Entries", in: managedContext)!
        let entry = NSManagedObject(entity: entity, insertInto: managedContext)
        
        entry.setValue(date, forKey: "date")
        entry.setValue(content, forKeyPath: "content")
        entry.setValue(image, forKey: "image")
        
        do {
            try managedContext.save()
            entries.append(entry)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func updateData(_ newBody: String, newDate: Date,index: Int){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext

        
        entries[entries.count-1-index].setValue(newBody, forKey: "content")
        entries[entries.count-1-index].setValue(newDate, forKey: "date")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func updateImage(image: UIImage){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
    
        entries[entries.count-1-0].setValue(image, forKey: "image")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Journal")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
    
    //hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}


