//
//  ImageCell.swift
//  Journal
//
//  Created by Kevin Hall on 6/7/18.
//  Copyright © 2018 Kevin Hall. All rights reserved.
//

import UIKit


public var cellFont: UIFont!

//mask layer to make rounded corners
let maskLayer = CAShapeLayer()
var path = UIBezierPath()

class ImageCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var dateLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //self.contentView.backgroundColor = COLOR_BG
        //self.contentView.layer.cornerRadius = 7
        //self.contentView.dropShadow(color: .lightGray, opacity: 0.7, offSet: CGSize(width: -1, height: 1), radius: 4, scale: true)
        //self.contentView.dropShadow(color: UIColor(rgb: 0x050505), opacity: 0.7, offSet: CGSize(width: -1, height: 1), radius: 4, scale: true)
        self.contentView.layer.cornerRadius = 3
        self.contentView.clipsToBounds = false
        //self.contentView.layer.borderColor = COLOR_TEXT.withAlphaComponent(0.2).cgColor
        //self.contentView.layer.borderWidth = 1
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = false
        imageView.layer.cornerRadius = 5
        //set the mask
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        
        dateLabel = UILabel()
        

            
        //dateLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dateLabel.clipsToBounds = true
        dateLabel.textAlignment = .left
        dateLabel.layer.cornerRadius = 7
        dateLabel.font = UIFont(
            name: "Avenir-Book",
            size: 8)!
        dateLabel.textColor = COLOR_TEXT
        dateLabel.clipsToBounds = true
        contentView.addSubview(dateLabel)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var frame = imageView.frame
        frame.size.height = 211
        frame.size.width = 161
        frame.origin.x = 2
        frame.origin.y = 2
        imageView.frame = frame
        //dateLabel.frame = CGRect(x: 3, y: 3, width: 80, height: 15)
        dateLabel.frame = CGRect(x: 2, y: -12, width: 80, height: 15)

        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ImageTextCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var dateLabel: UILabel!
    var contentLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //self.contentView.backgroundColor = COLOR_BG
        self.contentView.layer.cornerRadius = 3
        self.contentView.clipsToBounds = false
        //self.contentView.dropShadow(color: .lightGray, opacity: 0.2, offSet: CGSize(width: -1, height: 1), radius: 4, scale: true)
        //self.contentView.dropShadow(color: UIColor(rgb: 0x050505), opacity: 0.7, offSet: CGSize(width: -1, height: 1), radius: 4, scale: true)
        //self.contentView.layer.borderColor = COLOR_TEXT.withAlphaComponent(0.2).cgColor
        //self.contentView.layer.borderWidth = 1
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = false
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        
        dateLabel = UILabel()
        

        //dateLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dateLabel.clipsToBounds = true
        dateLabel.textAlignment = .left
        dateLabel.layer.cornerRadius = 7
        dateLabel.font = UIFont(
            name: "Avenir-Book",
            size: 8)!
        dateLabel.textColor = COLOR_TEXT
        dateLabel.clipsToBounds = true
        contentView.addSubview(dateLabel)
    

        contentLabel = UILabel()
        contentLabel.font = UIFont(
            name: "Avenir-Book",
            size: 11)!
        contentLabel.textColor = COLOR_TEXT
        contentLabel.clipsToBounds = true
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.numberOfLines = 9
        contentView.addSubview(contentLabel)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var frame = imageView.frame
        frame.size.height = 110
        frame.size.width = 161
        frame.origin.x = 2
        frame.origin.y = 2
        imageView.frame = frame
        //contentLabel.frame = CGRect(x: 5, y: 113, width: 155, height: 100)
        //dateLabel.frame = CGRect(x: 3, y: 3, width: 80, height: 15)
        dateLabel.frame = CGRect(x: 2, y: -12, width: 80, height: 15)

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class TextCell: UICollectionViewCell {
    
    var dateLabel: UILabel!
    var contentLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //self.contentView.backgroundColor = COLOR_BG
        self.contentView.layer.cornerRadius = 3
        self.contentView.clipsToBounds = false
        //self.contentView.dropShadow(color: .lightGray, opacity: 0.7, offSet: CGSize(width: -1, height: 1), radius: 4, scale: true)
        //self.contentView.dropShadow(color: UIColor(rgb: 0x050505), opacity: 0.7, offSet: CGSize(width: -1, height: 1), radius: 4, scale: true)
        //self.contentView.layer.borderColor = COLOR_TEXT.withAlphaComponent(0.2).cgColor
        //self.contentView.layer.borderWidth = 1

        dateLabel = UILabel()
        
        //dateLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dateLabel.clipsToBounds = true
        dateLabel.textAlignment = .left
        dateLabel.layer.cornerRadius = 7
        dateLabel.font = UIFont(
            name: "Avenir-Book",
            size: 8)!
        dateLabel.textColor = COLOR_TEXT.withAlphaComponent(0.2)
        dateLabel.clipsToBounds = true
        contentView.addSubview(dateLabel)
        
        contentLabel = UILabel()
        contentLabel.font = UIFont(
            name: "Avenir-Book",
            size: 11)!
        contentLabel.textColor = COLOR_TEXT
        contentLabel.clipsToBounds = true
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.numberOfLines = 12
        contentView.addSubview(contentLabel)
        
    }
    
    override func layoutSubviews() {

        super.layoutSubviews()
        var frame = contentLabel.frame
        frame.size.height = 205
        frame.size.width = 155
        frame.origin.x = 5
        frame.origin.y = 2

        contentLabel.frame = frame
        //dateLabel.frame = CGRect(x: 2, y: 5, width: 80, height: 15)
        dateLabel.frame = CGRect(x: 2, y: -12, width: 80, height: 15)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = COLOR_BG.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}





//
////
////  ImageCell.swift
////  Journal
////
////  Created by Kevin Hall on 6/7/18.
////  Copyright © 2018 Kevin Hall. All rights reserved.
////
//
//import UIKit
//
//
//public var cellFont: UIFont!
//
////mask layer to make rounded corners
//let maskLayer = CAShapeLayer()
//var path = UIBezierPath()
//
//class ImageCell: UICollectionViewCell {
//
//    var imageView: UIImageView!
//    var dateLabel: UILabel!
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        //self.contentView.backgroundColor = COLOR_BG
//        //self.contentView.layer.cornerRadius = 7
//        self.contentView.clipsToBounds = true
//        //self.contentView.dropShadow(color: .lightGray, opacity: 0.7, offSet: CGSize(width: -1, height: 1), radius: 4, scale: true)
//        //self.contentView.dropShadow(color: UIColor(rgb: 0x050505), opacity: 0.7, offSet: CGSize(width: -1, height: 1), radius: 4, scale: true)
//
//
//        imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.isUserInteractionEnabled = false
//        imageView.layer.cornerRadius = 2
//        //set the mask
//        imageView.clipsToBounds = true
//        contentView.addSubview(imageView)
//
//        dateLabel = UILabel()
//        //        dateLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        //        dateLabel.clipsToBounds = true
//        //        dateLabel.textAlignment = .center
//        //        dateLabel.layer.cornerRadius = 7
//        //        dateLabel.font = UIFont(
//        //            name: "Avenir-Black",
//        //            size: 10)!
//        //        dateLabel.textColor = UIColor.white.withAlphaComponent(0.7)
//        //        dateLabel.clipsToBounds = true
//        //        contentView.addSubview(dateLabel)
//
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        var frame = imageView.frame
//        frame.size.height = 211
//        frame.size.width = 161
//        frame.origin.x = 2
//        frame.origin.y = 2
//        imageView.frame = frame
//        dateLabel.frame = CGRect(x: 3, y: 3, width: 30, height: 15)
//
//    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//class ImageTextCell: UICollectionViewCell {
//
//    var imageView: UIImageView!
//    var dateLabel: UILabel!
//    var contentLabel: UILabel!
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        //self.contentView.backgroundColor = COLOR_BG
//        //self.contentView.layer.cornerRadius = 7
//        self.contentView.clipsToBounds = true
//        //self.contentView.dropShadow(color: .lightGray, opacity: 0.7, offSet: CGSize(width: -1, height: 1), radius: 4, scale: true)
//        //self.contentView.dropShadow(color: UIColor(rgb: 0x050505), opacity: 0.7, offSet: CGSize(width: -1, height: 1), radius: 4, scale: true)
//
//
//        imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.isUserInteractionEnabled = false
//        imageView.layer.cornerRadius = 2
//        imageView.clipsToBounds = true
//        contentView.addSubview(imageView)
//
//        dateLabel = UILabel()
//        //        dateLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        //        dateLabel.clipsToBounds = true
//        //        dateLabel.textAlignment = .center
//        //        dateLabel.layer.cornerRadius = 7
//        //        dateLabel.font = UIFont(
//        //            name: "Avenir-Black",
//        //            size: 10)!
//        //        dateLabel.textColor = UIColor.white.withAlphaComponent(0.7)
//        //        dateLabel.clipsToBounds = true
//        //        contentView.addSubview(dateLabel)
//
//        contentLabel = UILabel()
//        contentLabel.font = UIFont(
//            name: "Avenir-Book",
//            size: 11)!
//        contentLabel.textColor = COLOR_TEXT
//        contentLabel.clipsToBounds = true
//        contentLabel.lineBreakMode = .byWordWrapping
//        contentLabel.numberOfLines = 10
//        //contentLabel.sizeToFit()
//        contentView.addSubview(contentLabel)
//
//
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        var frame = imageView.frame
//        frame.size.height = 110
//        frame.size.width = 161
//        frame.origin.x = 2
//        frame.origin.y = 2
//        imageView.frame = frame
//        //contentLabel.frame = CGRect(x: 5, y: 113, width: 155, height: 100)
//        dateLabel.frame = CGRect(x: 3, y: 3, width: 30, height: 15)
//
//    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//
//class TextCell: UICollectionViewCell {
//
//    var dateLabel: UILabel!
//    var contentLabel: UILabel!
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        //self.contentView.backgroundColor = COLOR_BG
//        //self.contentView.layer.cornerRadius = 7
//        self.contentView.clipsToBounds = true
//        //self.contentView.dropShadow(color: .lightGray, opacity: 0.7, offSet: CGSize(width: -1, height: 1), radius: 4, scale: true)
//        //self.contentView.dropShadow(color: UIColor(rgb: 0x050505), opacity: 0.7, offSet: CGSize(width: -1, height: 1), radius: 4, scale: true)
//
//
//        dateLabel = UILabel()
//        //        dateLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        //        dateLabel.clipsToBounds = true
//        //        dateLabel.textAlignment = .center
//        //        dateLabel.layer.cornerRadius = 7
//        //        dateLabel.font = UIFont(
//        //            name: "Avenir-Black",
//        //            size: 10)!
//        //        dateLabel.textColor = UIColor.white.withAlphaComponent(0.7)
//        //        dateLabel.clipsToBounds = true
//        //        contentView.addSubview(dateLabel)
//
//        contentLabel = UILabel()
//        contentLabel.font = UIFont(
//            name: "Avenir-Book",
//            size: 11)!
//        contentLabel.textColor = COLOR_TEXT
//        contentLabel.clipsToBounds = true
//        contentLabel.lineBreakMode = .byWordWrapping
//        contentLabel.numberOfLines = 14
//        contentLabel.sizeToFit()
//        contentView.addSubview(contentLabel)
//
//    }
//
//    override func layoutSubviews() {
//
//        super.layoutSubviews()
//        var frame = contentLabel.frame
//        frame.size.height = 205
//        frame.size.width = 155
//        frame.origin.x = 5
//        frame.origin.y = 2
//
//        contentLabel.frame = frame
//        dateLabel.frame = CGRect(x: 2, y: 5, width: 30, height: 15)
//
//    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//
//
//extension UIView {
//
//    // OUTPUT 1
//    func dropShadow(scale: Bool = true) {
//        layer.masksToBounds = false
//        layer.shadowColor = COLOR_BG.cgColor
//        layer.shadowOpacity = 0.5
//        layer.shadowOffset = CGSize(width: -1, height: 1)
//        layer.shadowRadius = 1
//
//        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
//        layer.shouldRasterize = true
//        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
//    }
//
//    // OUTPUT 2
//    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
//        layer.masksToBounds = false
//        layer.shadowColor = color.cgColor
//        layer.shadowOpacity = opacity
//        layer.shadowOffset = offSet
//        layer.shadowRadius = radius
//
//        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//        layer.shouldRasterize = true
//        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
//    }
//}
