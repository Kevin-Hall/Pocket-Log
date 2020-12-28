//
//  Colors.swift
//  Journal
//
//  Created by Kevin Hall on 6/7/18.
//  Copyright © 2018 Kevin Hall. All rights reserved.
//
import UIKit

//var COLOR_BG = UIColor.white//UIColor(rgb: 0xEFEDE9)
//var COLOR_TEXT = UIColor.black
//var statusbar : UIStatusBarStyle = UIStatusBarStyle.default




var COLOR_BG = UserDefaults.standard.color(forKey: "COLOR_BG") ?? UIColor.black//UIColor(rgb: 0x101010)//
var COLOR_TEXT = UserDefaults.standard.color(forKey: "COLOR_TEXT") ?? UIColor.white
var statusbar : UIStatusBarStyle = UIStatusBarStyle.lightContent

var DATE_ON_CARD = UserDefaults.standard.bool(forKey: "DATE_ON_CARD")

var NOTIFICATIONS_ON = UserDefaults.standard.bool(forKey: "NOTIFICATIONS")


var COLOR_TEXT_HALF_ALPHA = UIColor.white.withAlphaComponent(0.5)
var dateColor = UIColor.black.withAlphaComponent(0.3)//UIColor(rgb: 0x53C8F9).withAlphaComponent(0.5)
var todayDateColor = UIColor(rgb: 0x343434)


//var gradientColor = UIColor(rgb: 0xE6E6E1).withAlphaComponent(0.5) // light
var gradientColor = UIColor(rgb: 0x191923).withAlphaComponent(0.5) //dark
var fontSize: CGFloat = CGFloat(UserDefaults.standard.integer(forKey: "fontSize")) //the fontsize of the tableview





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




extension UserDefaults {
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
        }
        set(colorData, forKey: key)// UserDefault Built-in Method into Any?
    }
    
    func color(forKey: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: forKey) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color
    }
}
