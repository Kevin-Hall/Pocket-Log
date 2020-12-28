//
//  CollectionHeader.swift
//  Journal
//
//  Created by Kevin Hall on 6/7/18.
//  Copyright © 2018 Kevin Hall. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView, CAAnimationDelegate {
    
    var monthLabel: UILabel
    var yearLabel: UILabel
    var menuBtn: UIButton
    //var monthBtn: UIButton
    var scrunched: Bool
    var addBtn: UIButton
    
    var animatingGradient: CAGradientLayer
    
    var bg: UIView
    
    
    let backToTodayButton: UIButton = {
        let button = UIButton()
        //button.setTitle("Today", for: .normal)
        //button.addTarget(self, action: #selector(postAction), for: .touchUpInside)
        //button.setTitleColor(COLOR_BG, for: .normal)
        //button.backgroundColor = COLOR_BG
        //button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 25)
        button.contentHorizontalAlignment = .center
        //button.layer.borderWidth = 0.5
        //button.layer.borderColor = COLOR_TEXT.withAlphaComponent(0.5).cgColor
        //button.backgroundColor = UIColor.white
        button.clipsToBounds = true
        button.layer.cornerRadius = 3
        
        
        return button
    }()
    
    
    let createTodayButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        //button.addTarget(self, action: #selector(postAction), for: .touchUpInside)
        button.setTitleColor(COLOR_BG, for: .normal)
        button.backgroundColor = UIColor.red
        //button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 40)
        button.contentHorizontalAlignment = .center
        button.layer.borderWidth = 0
        button.layer.borderColor = COLOR_TEXT.withAlphaComponent(0.5).cgColor
        button.backgroundColor = COLOR_TEXT
        button.clipsToBounds = true
        button.layer.cornerRadius = 3
        
        
        return button
    }()
    
    let monthBtn: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: -105, y: 40, width: 135, height: 60)
        button.backgroundColor = COLOR_TEXT
        button.layer.borderColor = COLOR_TEXT.withAlphaComponent(0.3).cgColor
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 12)
        return button
    }()
    
    let favoritesBtn: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.setImage(UIImage(named: "star-1")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = COLOR_TEXT
        button.alpha = 0
        return button
    }()
    
    let preferencesBtn: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.setImage(UIImage(named: "gear-1")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = COLOR_TEXT
        button.alpha = 0
        return button
    }()
    
    

    
    
    
    override class var layerClass: AnyClass {
        get { return CustomLayer.self }
    }

    override init(frame: CGRect) {
        monthLabel = UILabel()
        yearLabel = UILabel()
        menuBtn = UIButton()
        animatingGradient = CAGradientLayer()
        scrunched = Bool(false)
        bg = UIView()
        addBtn = UIButton()
        
        
        super.init(frame: frame)
        
        self.addSubview(bg)
        self.addSubview(monthLabel)
        self.addSubview(yearLabel)
        self.addSubview(menuBtn)
        self.addSubview(addBtn)
        

        
        self.addSubview(createTodayButton)
        self.addSubview(backToTodayButton)
        
        //self.addSubview(favoritesBtn)
        self.addSubview(preferencesBtn)
        
        
        createTodayButton.frame = CGRect(x: -90, y: 55, width: 50, height: 40)
        backToTodayButton.frame = CGRect(x: -120, y: 45, width: 120, height: 50)
        
        favoritesBtn.frame = CGRect(x: self.frame.width - 65, y: 50, width: 45, height: 45)
        preferencesBtn.frame = CGRect(x: self.frame.width - 65, y: 50, width: 45, height: 45)
        addBtn.frame = CGRect(x: self.frame.width - 50, y: 30, width: 45, height: 45)

        
        createTodayButton.setTitleColor(COLOR_TEXT, for: .normal)
        //createTodayButton.layer.borderColor = COLOR_TEXT.withAlphaComponent(0.5).cgColor
        createTodayButton.backgroundColor = COLOR_BG
        
        backToTodayButton.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .normal)
        //backToTodayButton.layer.borderColor = COLOR_TEXT.withAlphaComponent(0.5).cgColor
        //backToTodayButton.backgroundColor = COLOR_BG.withAlphaComponent(0.2)
        
        bg.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 100)
        //bg.backgroundColor = COLOR_BG.withAlphaComponent(0.88)
        bg.clipsToBounds = false
        bg.translatesAutoresizingMaskIntoConstraints = false
        //bg.layer.cornerRadius = 6
        
//        let path = UIBezierPath(roundedRect:bg.bounds,
//                                byRoundingCorners:[.topLeft,.topRight],
//                                cornerRadii: CGSize(width: 10 , height:  15))
//
//
//
//        let maskLayer = CAShapeLayer()
//        maskLayer.fillColor = UIColor.black.cgColor
//
//        maskLayer.path = path.cgPath
        bg.backgroundColor = COLOR_BG//UIColor(rgb: 0x0076FF)
//        bg.layer.mask = maskLayer
        bg.layer.shadowRadius = 3
        bg.layer.shadowOffset = CGSize(width: 0, height: 2)
        bg.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        bg.layer.shadowOpacity = 1
        
        
        let menuImg = UIImage(named: "menu")
        menuBtn.tintColor = COLOR_TEXT
        //menuBtn.imageView?.image?.withAlignmentRectInsets(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        menuBtn.setImage(menuImg, for: .normal)
        menuBtn.frame = CGRect(x: 5, y: 30, width: 45, height: 45)
        menuBtn.backgroundColor = UIColor.clear
    
        monthLabel.frame = CGRect(x: 50, y: 23, width: 250, height: 60)
        monthLabel.font = UIFont(name: "Avenir-Black", size: 27)!
        monthLabel.textColor = COLOR_TEXT
        monthLabel.textAlignment = .left
        monthLabel.numberOfLines = 1
        monthLabel.clipsToBounds = true
        monthLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        
        yearLabel.frame = CGRect(x: 50, y: 70, width: 250, height: 20)
        yearLabel.font = UIFont(name: "Avenir-Light", size: 12)!
        yearLabel.textColor = COLOR_TEXT.withAlphaComponent(0.5)
        yearLabel.textAlignment = .left
        yearLabel.numberOfLines = 1
        yearLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let addImg = UIImage(named: "plus")
        addBtn.tintColor = COLOR_TEXT
        //menuBtn.imageView?.image?.withAlignmentRectInsets(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        addBtn.setImage(addImg, for: .normal)
    }
    
    
    func showFavorites(){
        
        if self.scrunched{
            self.favoritesBtn.frame = CGRect(x: -55, y: 5, width: 45, height: 45)
        } else {
            self.favoritesBtn.frame = CGRect(x: -45, y: 40, width: 45, height: 45)
        }
        
        self.favoritesBtn.alpha = 1
        self.favoritesBtn.tintColor = UIColor(rgb: 0xFFC404)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations:{


            self.monthBtn.frame = self.monthBtn.frame.offsetBy(dx: -75, dy: 0)
            self.favoritesBtn.frame = self.favoritesBtn.frame.offsetBy(dx: 50, dy: 0)
        
        }, completion: { (success) -> Void in
            if self.scrunched{
                self.favoritesBtn.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }
        })
    }
    
    func hideFavorites(){
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations:{
            
            self.favoritesBtn.frame = self.favoritesBtn.frame.offsetBy(dx: -55, dy: 0)
            self.monthBtn.frame = self.monthBtn.frame.offsetBy(dx: 75, dy: 0)
        }, completion: { (success) -> Void in
            self.favoritesBtn.frame = CGRect(x: self.frame.width - 65, y: 50, width: 45, height: 45)
            self.favoritesBtn.alpha = 0
        
            self.favoritesBtn.tintColor = COLOR_TEXT
            self.favoritesBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    
    }
    
   

//    func hideMonth(){
//
//        //self.monthBtn.setTitle("NEW", for: .normal)
//        self.menuBtn.alpha = 0
//
//        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations:{
//            self.monthLabel.frame = self.monthLabel.frame.offsetBy(dx: -250, dy: 0)
//            self.yearLabel.frame = self.yearLabel.frame.offsetBy(dx: -250, dy: 0)
//            self.monthBtn.frame = self.monthBtn.frame.offsetBy(dx: -100, dy: 0)
//
//            self.favoritesBtn.frame = self.favoritesBtn.frame.offsetBy(dx: -80*2, dy: 0)
//            self.preferencesBtn.frame = self.preferencesBtn.frame.offsetBy(dx: -80, dy: 0)
//            self.favoritesBtn.alpha = 1
//            self.preferencesBtn.alpha = 1
//            self.menuBtn.alpha = 1
//
//
//        }, completion: { (success) -> Void in
//            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 17, initialSpringVelocity: 0.0, options: [], animations: {
//               // self.monthBtn.layer.borderWidth = 0.5
//                //self.monthBtn.frame = self.monthBtn.frame.insetBy(dx: -400, dy: 0)
//
//
//                self.createTodayButton.frame = self.createTodayButton.frame.offsetBy(dx: 110, dy: 0)
//                //self.backToTodayButton.frame = self.backToTodayButton.frame.offsetBy(dx: 125, dy: 0)
//
//
//
//
//                self.monthLabel.frame = self.monthLabel.frame.offsetBy(dx: -100, dy: 0)
//                self.yearLabel.frame = self.yearLabel.frame.offsetBy(dx: -100, dy: 0)
//            })
//        })
//
//
//    }
//
//    func unhideMonth(){
//
//        self.menuBtn.alpha = 0
//
//        UIView.animate(withDuration: 0.30, delay: 0, options: [.curveEaseInOut], animations:{
//            self.monthLabel.frame = self.monthLabel.frame.offsetBy(dx: 350, dy: 0)
//            self.yearLabel.frame = self.yearLabel.frame.offsetBy(dx: 350, dy: 0)
//
//            self.createTodayButton.frame = self.createTodayButton.frame.offsetBy(dx: -110, dy: 0)
//            //self.backToTodayButton.frame = self.backToTodayButton.frame.offsetBy(dx: -125, dy: 0)
//
//            self.monthBtn.frame = self.monthBtn.frame.offsetBy(dx: 100, dy: 0)
//            //self.monthBtn.frame = self.monthBtn.frame.insetBy(dx: 400, dy: 0)
//
//            self.favoritesBtn.frame = self.favoritesBtn.frame.offsetBy(dx: 80*2, dy: 0)
//            self.preferencesBtn.frame = self.preferencesBtn.frame.offsetBy(dx: 80, dy: 0)
//            self.favoritesBtn.alpha = 0
//            self.preferencesBtn.alpha = 0
//            self.menuBtn.alpha = 1
//
//
//        }, completion: { (success) -> Void in
//            //self.monthBtn.layer.borderWidth = 0
//            //self.monthBtn.setTitle("", for: .normal)
//
//        })
//    }
    
    func scrunchHeader(withFavorites: Bool){
        print("scrunch")
        
        UIView.animate(withDuration: 0.20, delay: 0, options: [.curveEaseInOut], animations:{


            
            self.createTodayButton.frame = self.createTodayButton.frame.offsetBy(dx: 0, dy: -40)
            self.backToTodayButton.frame = self.backToTodayButton.frame.offsetBy(dx: 0, dy: -40)
            self.backToTodayButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            self.menuBtn.frame = self.menuBtn.frame.offsetBy(dx: 0, dy: -30)
            self.addBtn.frame = self.addBtn.frame.offsetBy(dx: 0, dy: -30)
            self.favoritesBtn.frame = self.favoritesBtn.frame.offsetBy(dx: 0, dy: -40)
            self.preferencesBtn.frame = self.preferencesBtn.frame.offsetBy(dx: 0, dy: -40)
            self.monthLabel.frame = self.monthLabel.frame.offsetBy(dx: -50, dy: -30)
            self.monthLabel.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            self.monthBtn.frame = self.monthBtn.frame.offsetBy(dx: 0, dy: -30)
            self.monthBtn.layer.cornerRadius = 3
            self.monthBtn.transform = CGAffineTransform(scaleX: 0.8, y: 1)
            self.monthBtn.frame = CGRect(x: self.monthBtn.frame.minX, y: self.monthBtn.frame.minY, width: self.monthBtn.frame.width, height: self.monthBtn.frame.height - 20)
            self.yearLabel.frame = self.yearLabel.frame.offsetBy(dx: -20, dy: -40)
            self.yearLabel.alpha = 0
            self.bg.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 50)
            
        }, completion: { (success) -> Void in
        })
    }
    
    func unscrunchHeader(withFavorites: Bool){
        print("unscrunch")
        UIView.animate(withDuration: 0.30, delay: 0, options: [.curveEaseInOut], animations:{

            
            self.createTodayButton.frame = self.createTodayButton.frame.offsetBy(dx: 0, dy: 40)
            self.backToTodayButton.frame = self.backToTodayButton.frame.offsetBy(dx: 0, dy: 40)
            self.backToTodayButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.menuBtn.frame = self.menuBtn.frame.offsetBy(dx: 0, dy: 30)
            self.addBtn.frame = self.addBtn.frame.offsetBy(dx: 0, dy: 30)
            self.favoritesBtn.frame = self.favoritesBtn.frame.offsetBy(dx: 0, dy: 40)
            self.preferencesBtn.frame = self.preferencesBtn.frame.offsetBy(dx: 0, dy: 40)
            self.monthLabel.frame = self.monthLabel.frame.offsetBy(dx: 50, dy: 30)
            self.monthLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.monthBtn.frame = self.monthBtn.frame.offsetBy(dx: 0, dy: 30)
            self.monthBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.monthBtn.layer.cornerRadius = 5
            self.monthBtn.frame = CGRect(x: self.monthBtn.frame.minX, y: self.monthBtn.frame.minY, width: self.monthBtn.frame.width, height: self.monthBtn.frame.height + 20)
            self.yearLabel.frame = self.yearLabel.frame.offsetBy(dx: 20, dy: 40)
            self.yearLabel.alpha = 1
            self.bg.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 100)
            
            
        }, completion: { (success) -> Void in
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}






class CollectionFooterView: UICollectionReusableView {
    
    var todayLabel: UILabel
    var menuBtn: UIButton
    
    
    override class var layerClass: AnyClass {
        get { return CustomLayer.self }
    }
    
    override init(frame: CGRect) {
        
        todayLabel = UILabel()
        menuBtn = UIButton()
        super.init(frame: frame)
    
        menuBtn.backgroundColor = COLOR_TEXT
        menuBtn.layer.cornerRadius = 2
        menuBtn.clipsToBounds = true
        menuBtn.setTitle("bhbjk", for: .normal)
        

        todayLabel.frame = CGRect(x: 30, y: 0, width: 250, height: 60)
        todayLabel.font = UIFont(name: "Avenir-Roman", size: 12)!
        todayLabel.textColor = COLOR_TEXT.withAlphaComponent(0.3)
        todayLabel.textAlignment = .left
        todayLabel.text = "Create new entry TODAY"
        todayLabel.numberOfLines = 1
        todayLabel.backgroundColor = COLOR_BG
        todayLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        todayLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



extension UIButton {
    func applyGradientCircle() {
        let gradient = CAGradientLayer()
//        gradient.colors = [UIColor(rgb: 0xFE09AD).cgColor,
//                           UIColor(rgb: 0xFFA415).cgColor,]
        gradient.colors = [UIColor(rgb: 0x007AFF).cgColor,
                           UIColor(rgb: 0x0046FF).cgColor,]
        gradient.locations = [0.0, 1.0]
        gradient.frame = self.bounds
        
        let maskLayer = CAShapeLayer()
        var path = UIBezierPath()
        
        path = UIBezierPath(roundedRect:self.bounds,byRoundingCorners:[.allCorners],cornerRadii: CGSize(width: 25 ,height: 250))
        maskLayer.fillColor = COLOR_BG.cgColor
        maskLayer.path = path.cgPath
        gradient.mask = maskLayer
        
        self.layer.insertSublayer(gradient, at: 2)
        self.layer.cornerRadius = 25
        
    }

    
    func applyShadow() {
        var shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 25).cgPath
        shadowLayer.fillColor = UIColor.clear.cgColor
        
        shadowLayer.shadowColor = UIColor(rgb: 0xFE09AD).cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 1, height: 1)
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowRadius = 4
        
        layer.insertSublayer(shadowLayer, at: 1)
    }
}



class CustomLayer: CALayer {
    override var zPosition: CGFloat {
        get { return 1 }
        set {}
    }
}
