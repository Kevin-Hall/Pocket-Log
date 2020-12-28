//
//  NewPostVC.swift
//  Journal
//
//  Created by Kevin Hall on 6/18/18.
//  Copyright © 2018 Kevin Hall. All rights reserved.
//

import Foundation
import UIKit
import TLPhotoPicker
import DateTimePicker
import CoreData
import FSCalendar

class NewPost: UIViewController,  UITextViewDelegate, TLPhotosPickerViewControllerDelegate, UINavigationControllerDelegate, DateTimePickerDelegate, FSCalendarDelegate, FSCalendarDataSource{
    
    
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        selectedDate = picker.selectedDate
    }
    
    
    let imagePicker = TLPhotosPickerViewController()
    let modelFactory = ModelFactory()
    
    
    var entry: NSManagedObject! = nil
    
    let df = DateFormatter()
    
    var selectedDate = Date()
    var content: String?
    var image: UIImage?
    var newPost = true
    
    var picker: DateTimePicker?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = COLOR_BG
        
        
        self.view.addSubview(scrollView)
        self.view.addSubview(postButton)
        self.view.addSubview(cancelButton)
        self.scrollView.addSubview(imageView)
        self.scrollView.addSubview(selectImageButton)
        self.scrollView.addSubview(textView)
        self.scrollView.addSubview(dateButton)
        

        
        if let content = content{
            textView.text = content
        }
        
        if let image = image{
            imageView.image = image
            selectImageButton.setTitle("Remove Image", for: .normal)
        } else {
            imageView.image = UIImage()
        }
        
        
        textView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        df.dateFormat = "MMMM d"
        dateButton.setTitle(df.string(from: self.selectedDate), for: .normal)
        

        
        
        
    }
    
    override func viewWillLayoutSubviews() {
        postButton.frame = CGRect(x: self.view.bounds.width/2 + 20, y: self.view.bounds.height - 60, width: self.view.bounds.width/2 - 40, height: 40)
        cancelButton.frame = CGRect(x: 20, y: self.view.bounds.height - 60, width: self.view.bounds.width/2 - 40, height: 40)
        imageView.frame = CGRect(x: 20, y: 0, width: self.view.frame.width - 40, height: 120)
        selectImageButton.frame = CGRect(x: self.view.frame.width - 130, y: 5, width: 100, height: 30)
        
        
        //set the content frame and text
        let labelHeight = textView.heightForView(text: textView.text, font: UIFont(name: "Avenir-Roman", size: 14)!, width: self.view.frame.width - 40)
        textView.frame = CGRect(x: 20, y: self.imageView.frame.height + 50, width: self.view.frame.width - 40, height: labelHeight)
        
        self.scrollView.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: self.view.frame.width , height: self.view.frame.height)
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: imageView.frame.height + labelHeight + 100)
        
        dateButton.frame = CGRect(x: 20, y: 130, width: self.view.frame.width - 30, height: 40)
        scrollView.frame = CGRect(x: 0, y:  UIApplication.shared.statusBarFrame.height, width: self.view.bounds.width, height: self.view.bounds.height-120)
    }
    
    @objc func cancelAction() {
        self.dismiss(animated: true) {
            
            
        }
    }
    
    
    @objc func postAction() {
        self.dismiss(animated: true) {
        
            if self.newPost{
                if self.textView.textColor == COLOR_TEXT.withAlphaComponent(0.5)  {
                    self.modelFactory.save(date: self.selectedDate, content: "", image: self.imageView.image!)
                } else if self.imageView.image != nil{
                    self.modelFactory.save(date: self.selectedDate, content: self.textView.text, image: self.imageView.image!)
                } else {
                    self.modelFactory.save(date: self.selectedDate, content: self.textView.text, image: UIImage())
                }
            } else{
                //entries.removeAll()
                //entriesThisMonth.removeAll()
                self.modelFactory.updateData(self.textView.text, newDate: self.selectedDate, newimage: self.imageView.image!, entry: self.entry)
            }
            NotificationCenter.default.post(name: .reloadCoreData, object: nil)
        }
    }
    
    @objc func selectImageAction() {
        
        if selectImageButton.titleLabel?.text == "Remove Image" {
            imageView.image = UIImage()
            selectImageButton.setTitle("Select Image", for: .normal)
        } else {
            //then open the image picker
            imagePicker.delegate = self
            imagePicker.configure.maxSelectedAssets = 1
            imagePicker.configure.selectedColor = UIColor.black
            //configure.nibSet = (nibName: "CustomCell_Instagram", bundle: Bundle.main) // If you want use your custom cell..
            self.present(imagePicker, animated: true, completion: nil)
        }
    }


    //TLPhotosPickerViewControllerDelegate
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        // use selected order, fullresolution image
        //self.selectedAssets = withTLPHAssets
        
        imageView.image = withTLPHAssets.first?.fullResolutionImage
        selectImageButton.setTitle("Remove Image", for: .normal)

        
        //let imageData = withTLPHAssets.first?.fullResolutionImage?.toData
        
        
//        let options = [kCGImageSourceShouldCache as String: kCFBooleanFalse]
//        if let imgSrc = CGImageSourceCreateWithData(imageData as! CFData, options as CFDictionary) {
//            let metadata = CGImageSourceCopyPropertiesAtIndex(imgSrc, 0, options as CFDictionary) as? [String : AnyObject]
//            
//            print(metadata)
//            
//            if let gpsData = metadata?[kCGImagePropertyGPSDictionary as String] {
//                //do interesting stuff here
//                print(gpsData)
//            }
//        }
        
        
    }
//    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
//        // if you want to used phasset.
//
//    }
    func photoPickerDidCancel() {
        // cancel
    }
    func dismissComplete() {
        // picker viewcontroller dismiss completion
    }
//    func canSelectAsset(phAsset: PHAsset) -> Bool {
//        //Custom Rules & Display
//        //You can decide in which case the selection of the cell could be forbidden.
//    }
    func didExceedMaximumNumberOfSelection(picker: TLPhotosPickerViewController) {
        // exceed max selection
    }
    func handleNoAlbumPermissions(picker: TLPhotosPickerViewController) {
        // handle denied albums permissions case
    }
    func handleNoCameraPermissions(picker: TLPhotosPickerViewController) {
        // handle denied camera permissions case
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        //toolbar stuff
        let dateToolBar: UIToolbar = UIToolbar(frame: CGRect(x:0, y:0, width:self.view.frame.width,height: 60))
        dateToolBar.setBackgroundImage(UIImage(),
                                       forToolbarPosition: .any,
                                       barMetrics: .default)
        dateToolBar.setShadowImage(UIImage(), forToolbarPosition: .any)
        dateToolBar.backgroundColor = UIColor.clear
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
//        let add: UIBarButtonItem = UIBarButtonItem(title: "Add Image", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.addImage))
//        add.setTitleTextAttributes([NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): bgColor,NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont(name: "Open Sans", size: 14)!], for: .normal)
//
     
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "↓", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.done))
        done.setTitleTextAttributes([NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): COLOR_TEXT,NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont(name: "Avenir-Book", size: 20)!], for: .normal)
        
        dateToolBar.tintColor = UIColor.white
        dateToolBar.items = [flexSpace,done]
        dateToolBar.sizeToFit()
        
        
        if !self.newPost {
            textView.textColor = COLOR_TEXT
        }
        
        
        textView.inputAccessoryView = dateToolBar
        
        
        let pointInTable:CGPoint = textView.superview!.convert(textView.frame.origin, to: scrollView)
        var contentOffset:CGPoint = scrollView.contentOffset
        contentOffset.y  = pointInTable.y
        if let accessoryView = textView.inputAccessoryView {
            contentOffset.y -= accessoryView.frame.size.height
        }
        
        textView.frame = CGRect(x: 20, y: self.imageView.frame.height + 50, width: self.view.frame.width - 40, height: self.view.bounds.height/2 - 20)
        
        scrollView.setContentOffset(contentOffset, animated: true)
        scrollView.isScrollEnabled = false
        textView.isScrollEnabled = true
        return true
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == COLOR_TEXT.withAlphaComponent(0.5) {
            textView.text = nil
            textView.textColor = COLOR_TEXT
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write a caption..."
            textView.textColor = COLOR_TEXT.withAlphaComponent(0.5)
        }
    }
    
    
    @objc func done() {
        self.view.endEditing(true)
    }
    
    @objc func openDatePicker() {

        if self.childViewControllers.count >= 1{
            var vcToRemove : UIViewController!
            
            for vc in self.childViewControllers{
                if vc.title == "menu" {
                    vcToRemove = vc
                }
            }
        
            //animate view back down
            UIView.animate(withDuration: 0.30, delay: 0, options: [.curveEaseInOut], animations:{
                vcToRemove.view.frame = vcToRemove.view.frame.offsetBy(dx:  0, dy: 310)
            }, completion: { (success) -> Void in
                vcToRemove.removeFromParentViewController()
            })
        } else {
            let menuVC = Calendar()
            
            menuVC.title = "menu"
            self.addChildViewController(menuVC)
            menuVC.didMove(toParentViewController: self)
            self.view.addSubview(menuVC.view)
            menuVC.view.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 290)
            
            menuVC.calendar.delegate = self
            menuVC.calendar.dataSource = self
            menuVC.calendar.setCurrentPage(self.selectedDate, animated: false)

            
            UIView.animate(withDuration: 0.30, delay: 0, options: [.curveEaseInOut], animations:{
                menuVC.view.frame = menuVC.view.frame.offsetBy(dx:  0, dy: -310)
            }, completion: { (success) -> Void in
                self.view.hideAllToasts()
                //self.scrollView.isScrollEnabled = false
            })
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification){
        postButton.alpha = 0
        cancelButton.alpha = 0

        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        
        scrollView.isScrollEnabled = true
        textView.isScrollEnabled = false

        let contentInsets = UIEdgeInsets.zero
        postButton.alpha = 1
        cancelButton.alpha = 1
        
        //set the content frame and text
        let labelHeight = textView.heightForView(text: textView.text, font: UIFont(name: "Avenir-Roman", size: 14)!, width: self.view.frame.width - 40)
        textView.frame = CGRect(x: 20, y: self.imageView.frame.height + 50, width: self.view.frame.width - 40, height: labelHeight)
        
        self.scrollView.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: self.view.frame.width , height: self.view.frame.height)
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: imageView.frame.height + textView.frame.height + 350)
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectedDate = date
        df.dateFormat = "MMMM d"
        dateButton.setTitle(df.string(from: self.selectedDate), for: .normal)
        
        
        var vcToRemove : UIViewController!
        for vc in self.childViewControllers{
            if vc.title == "menu" {
                vcToRemove = vc
            }
        }
        
        //animate view back down
        UIView.animate(withDuration: 0.30, delay: 0, options: [.curveEaseInOut], animations:{
            vcToRemove.view.frame = vcToRemove.view.frame.offsetBy(dx:  0, dy: 310)
        }, completion: { (success) -> Void in
            vcToRemove.removeFromParentViewController()
        })
    }
    
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = COLOR_BG
        scrollView.clipsToBounds = true
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.text = "Write a caption..."
        textView.tintColor = COLOR_TEXT
        textView.font = UIFont(name: "Avenir-Roman", size: 14)
        textView.textColor = COLOR_TEXT.withAlphaComponent(0.5)
        textView.backgroundColor = UIColor.clear
        textView.clipsToBounds = true
        textView.isScrollEnabled = false
        return textView
    }()
    
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = COLOR_TEXT.withAlphaComponent(0.1)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 3
        
        return imageView
    }()
    
    let selectImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select Image", for: .normal)
        button.addTarget(self, action: #selector(selectImageAction), for: .touchUpInside)
        button.setTitleColor(COLOR_TEXT, for: .normal)
        button.backgroundColor = COLOR_BG
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 12)
        return button
    }()
    
    let dateButton: UIButton = {
        let button = UIButton()
        //button.setTitle(df.strring, for: .normal)
        button.addTarget(self, action: #selector(openDatePicker), for: .touchUpInside)
        button.setTitleColor(COLOR_TEXT, for: .normal)
        button.backgroundColor = COLOR_BG
        button.layer.cornerRadius = 5
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 22)
        return button
    }()
    
    
    let postButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(postAction), for: .touchUpInside)
        button.setTitleColor(COLOR_TEXT, for: .normal)
        button.backgroundColor = COLOR_TEXT.withAlphaComponent(0.1)
        button.clipsToBounds = true
        button.layer.cornerRadius = 3
        button.titleLabel?.font = UIFont(name: "Avenir-Light", size: 14)
        return button
    }()
    
   
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        button.setTitleColor(COLOR_TEXT, for: .normal)
        button.backgroundColor = COLOR_TEXT.withAlphaComponent(0.1)
        button.clipsToBounds = true
        button.layer.cornerRadius = 3
        button.setImage(UIImage(named: "x-1"), for: .normal)
        button.titleLabel?.font  = UIFont(name: "Avenir-Light", size: 14)
        return button
    }()
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if UserDefaults.standard.color(forKey: "COLOR_BG") == UIColor.white {
            return .default
        } else {
            return .lightContent
        }
        return statusbar
    }
    
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
}
