//
//  ImageCell.swift
//  Journal
//
//  Created by Kevin Hall on 6/7/18.
//  Copyright © 2018 Kevin Hall. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var dateLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = false
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        
        dateLabel = UILabel()
        dateLabel.text = "May 31"
        dateLabel.font = UIFont.systemFont(ofSize: 11)
        dateLabel.textColor = UIColor.black.withAlphaComponent(0.3)
        dateLabel.clipsToBounds = true
        contentView.addSubview(dateLabel)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var frame = imageView.frame
        frame.size.height = 195
        frame.size.width = 160
        frame.origin.x = 14
        frame.origin.y = 17
        imageView.frame = frame
        dateLabel.frame = CGRect(x: 14, y: 0, width: 160, height: 15)
        
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
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = false
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        
        dateLabel = UILabel()
        dateLabel.text = "May 31"
        dateLabel.font = UIFont.systemFont(ofSize: 11)
        dateLabel.textColor = UIColor.black.withAlphaComponent(0.3)
        dateLabel.clipsToBounds = true
        contentView.addSubview(dateLabel)

        contentLabel = UILabel()
        contentLabel.font = UIFont(
            name: "Avenir-Light",
            size: 11)!
        contentLabel.textColor = UIColor.black
        contentLabel.clipsToBounds = true
        contentLabel.layer.cornerRadius = 2
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.numberOfLines = 20
        contentView.addSubview(contentLabel)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var frame = imageView.frame
        frame.size.height = 100
        frame.size.width = 160
        frame.origin.x = 14
        frame.origin.y = 17
        imageView.frame = frame
        contentLabel.frame = CGRect(x: 14, y: 115, width: 160, height: 100)
        
        //contentLabel.frame = CGRect(x: 60, y: 15, width: 300, height: 30)
        dateLabel.frame = CGRect(x: 14, y: 0, width: 160, height: 15)
        
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
        
        dateLabel = UILabel()
        dateLabel.text = "May 31"
        dateLabel.font = UIFont.boldSystemFont(ofSize: 14)
        dateLabel.textColor = UIColor.black
        dateLabel.clipsToBounds = true
        contentView.addSubview(dateLabel)
        
        contentLabel = UILabel()
        contentLabel.font = UIFont.systemFont(ofSize: 12)
        contentLabel.textColor = UIColor.black
        contentLabel.clipsToBounds = true
        contentLabel.layer.cornerRadius = 2
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.numberOfLines = 20
        contentView.addSubview(contentLabel)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        frame.size.height = 210
        frame.size.width = 160
        frame.origin.x = 14
        frame.origin.y = 0
        contentLabel.frame = CGRect(x: 14, y: 20, width: 160, height: 180)
        dateLabel.frame = CGRect(x: 14, y: 0, width: 160, height: 15)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


