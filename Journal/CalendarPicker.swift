//
//  CalendarPicker.swift
//  Journal
//
//  Created by Kevin Hall on 9/26/18.
//  Copyright © 2018 Kevin Hall. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar


class CalendarPicker: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance, CAAnimationDelegate {
    
    
    var calendar : FSCalendar!
    
    var currGradient: Int = currentGradient
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    
    var blurEffectView = UIVisualEffectView(effect: nil)
    
    

    
    
    let leftButton: UIButton = {
        let button = UIButton()
        let img = UIImage(named: "leftArrow")?.withRenderingMode(.alwaysTemplate)
        button.tintColor = COLOR_TEXT
        button.setImage(img, for: .normal)
        button.contentHorizontalAlignment = .center
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    
    let rightButton: UIButton = {
        let button = UIButton()
        let img = UIImage(named: "rightArrow")?.withRenderingMode(.alwaysTemplate)
        button.tintColor = COLOR_TEXT
        button.setImage(img, for: .normal)
        button.contentHorizontalAlignment = .center
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        return button
    }()
    
    
    func themeChanged(){
        
        blurEffectView.removeFromSuperview()
        
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        
        if UserDefaults.standard.color(forKey: "COLOR_BG") == UIColor.white {
            blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        }
        
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        
        calendar.appearance.headerTitleColor = COLOR_TEXT
        calendar.appearance.selectionColor = COLOR_TEXT
        calendar.appearance.titleSelectionColor = COLOR_BG
        calendar.appearance.weekdayTextColor = COLOR_TEXT.withAlphaComponent(0.5)
        calendar.appearance.todaySelectionColor = COLOR_TEXT
        calendar.appearance.todayColor = COLOR_BG.withAlphaComponent(0.5)
        calendar.appearance.titleTodayColor = COLOR_TEXT
        calendar.appearance.titleDefaultColor = COLOR_TEXT.withAlphaComponent(0.8)
        calendar.appearance.eventSelectionColor = COLOR_TEXT
        calendar.appearance.eventDefaultColor = COLOR_TEXT.withAlphaComponent(0.1)
        calendar.appearance.borderSelectionColor = COLOR_TEXT
        
        leftButton.tintColor = COLOR_TEXT
        leftButton.backgroundColor = COLOR_TEXT.withAlphaComponent(0.05)
        rightButton.tintColor = COLOR_TEXT
        rightButton.backgroundColor = COLOR_TEXT.withAlphaComponent(0.05)
        self.view.backgroundColor = COLOR_BG.withAlphaComponent(0.2)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.cornerRadius = 0
        self.view.clipsToBounds = true
        self.view.backgroundColor = COLOR_BG.withAlphaComponent(0.2)
        
        
        
        
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        
        if UserDefaults.standard.color(forKey: "COLOR_BG") == UIColor.white {
            blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        }
        
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        
        //        preferencesButton.frame = CGRect(x: (self.view.frame.width - 20)/2, y: 300, width: (self.view.frame.width - 20)/2, height: 60)
        //        favoritesButton.frame = CGRect(x: 0, y: 300, width: (self.view.frame.width - 20)/2, height: 60)
        
        
        leftButton.frame = CGRect(x: 0, y: 15, width: 35, height: 50)
        rightButton.frame = CGRect(x: self.view.frame.width-35, y: 15, width: 35, height: 50)
        
        calendar = FSCalendar(frame: CGRect(x: 40, y: 0, width: self.view.frame.width-80, height: 290))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.clipsToBounds = false
        
        let formatter = DateFormatter()
        formatter.dateFormat = "mmm yy"
        
        //appearance
        calendar.allowsMultipleSelection = false
        calendar.appearance.headerMinimumDissolvedAlpha = 0.00
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.appearance.caseOptions = [.weekdayUsesSingleUpperCase]
        calendar.appearance.headerTitleFont = UIFont(name: "Avenir-Black", size: CGFloat(0))
        calendar.appearance.titleFont = UIFont(name: "Avenir-Black", size: 12)!
        calendar.headerHeight = 18
        calendar.weekdayHeight = 8
        calendar.placeholderType = FSCalendarPlaceholderType.none
        //calendar.calendarWeekdayView.frame.offsetBy(dx: 0, dy: 10)
        calendar.appearance.headerTitleColor = COLOR_TEXT
        calendar.appearance.selectionColor = COLOR_TEXT
        calendar.appearance.titleSelectionColor = COLOR_BG
        calendar.appearance.headerDateFormat = "MMMM"
        calendar.appearance.weekdayTextColor = COLOR_TEXT.withAlphaComponent(0.5)
        calendar.appearance.weekdayFont = UIFont(name: "Avenir-Roman", size: 8)!
        calendar.appearance.todaySelectionColor = COLOR_TEXT
        calendar.appearance.todayColor = COLOR_BG.withAlphaComponent(0.5)
        calendar.appearance.titleTodayColor = COLOR_TEXT
        calendar.appearance.titleDefaultColor = COLOR_TEXT.withAlphaComponent(0.8)
        calendar.appearance.eventSelectionColor = COLOR_TEXT
        calendar.appearance.eventDefaultColor = COLOR_TEXT.withAlphaComponent(0.1)
        calendar.appearance.borderSelectionColor = COLOR_TEXT
        calendar.appearance.borderRadius = 0.33
        calendar.collectionView.isPagingEnabled = true
        
        
        calendar.scrollDirection = .horizontal
        calendar.scope = .week
        calendar.locale = .current
        
        
        calendar.contentView.isUserInteractionEnabled = true
        calendar.clipsToBounds = true
        
        
        
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        
    }
    
    let dateFindingformatter = DateFormatter() //used to set the date of each cell
    
    
    
    
    
    
    
    func animateGradient() {
        if currGradient < gradientSet.count - 1 {
            currGradient += 1
        } else {
            currGradient = 0
        }
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.delegate = self
        gradientChangeAnimation.duration = 10
        gradientChangeAnimation.toValue = gradientSet[currGradient]
        gradientChangeAnimation.fillMode = kCAFillModeForwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradient.add(gradientChangeAnimation, forKey: "colorChange")
        
        
    }
    
    
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print(self.calendar.currentPage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        var g1 = UIColor(rgb: 0x00E2E8).withAlphaComponent(0.25).cgColor
        //        var g2 = UIColor(rgb: 0x4643FF).withAlphaComponent(0.25).cgColor
        //        var g3 = UIColor(rgb: 0xFE09AD).withAlphaComponent(0.25).cgColor
        //        var g4 = UIColor(rgb: 0xFFA415).withAlphaComponent(0.25).cgColor
        //        var g5 = UIColor(rgb: 0xFFFF00).withAlphaComponent(0.25).cgColor
        
        
        
        var g1 = UIColor(rgb: 0x3439D8).withAlphaComponent(0.3).cgColor
        var g2 = UIColor(rgb: 0xBF34FB).withAlphaComponent(0.3).cgColor
        
        //        if UserDefaults.standard.color(forKey: "COLOR_BG") == UIColor.white {
        //            g1 = UIColor(rgb: 0x00E2E8).withAlphaComponent(0.4).cgColor
        //            g2 = UIColor(rgb: 0x4643FF).withAlphaComponent(0.4).cgColor
        ////            g3 = UIColor(rgb: 0xFE09AD).withAlphaComponent(0.4).cgColor
        ////            g4 = UIColor(rgb: 0xFFA415).withAlphaComponent(0.4).cgColor
        ////            g5 = UIColor(rgb: 0xFFFF00).withAlphaComponent(0.4).cgColor
        //        }
        
        
        //        gradientSet.append([g3, g4])
        //        gradientSet.append([g4, g5])
        //        gradientSet.append([g5, g1])
        
        
        let theme = UserDefaults.standard.string(forKey: "COLOR_THEME")
        
        switch theme {
        case "Cool":
            g1 = UIColor(rgb: 0x3439D8).withAlphaComponent(0.3).cgColor
            g2 = UIColor(rgb: 0xBF34FB).withAlphaComponent(0.3).cgColor
            break
        case "Warm":
            g1 = UIColor(rgb: 0xFE09AD).withAlphaComponent(0.3).cgColor
            g2 = UIColor(rgb: 0xFFA415).withAlphaComponent(0.3).cgColor
            break
        default:
            g1 = UIColor(rgb: 0x3439D8).withAlphaComponent(0.3).cgColor
            g2 = UIColor(rgb: 0xBF34FB).withAlphaComponent(0.3).cgColor
            break
        }
        
        //gradientSet.append([g1, g2])
        //gradientSet.append([g2, g1])
        
        g1 = UIColor(rgb: 0xFF8800).withAlphaComponent(0.3).cgColor
        g2 = UIColor(rgb: 0xFF9B0A).withAlphaComponent(0.3).cgColor
        let g3 = UIColor(rgb: 0xCD45DF).withAlphaComponent(0.3).cgColor
        let g4 = UIColor(rgb: 0x420EBE).withAlphaComponent(0.3).cgColor
        
        
        gradientSet.append([g1, g2])
        gradientSet.append([g2, g3])
        
        gradientSet.append([g3, g4])
        gradientSet.append([g4, g1])
        
        
        
        gradient.frame = self.calendar.bounds
        gradient.colors = gradientSet[currGradient]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        gradient.drawsAsynchronously = true
        //self.view.layer.addSublayer(gradient)
        
        self.view.addSubview(calendar)
        //self.view.addSubview(preferencesButton)
        //self.view.addSubview(favoritesButton)
        self.view.addSubview(leftButton)
        self.view.addSubview(rightButton)
        
        
        animateGradient()
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currGradient]
            animateGradient()
        }
    }
    
    
    
    
}
