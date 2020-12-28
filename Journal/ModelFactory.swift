//
//  ModelFactory.swift
//  Journal
//
//  Created by Kevin Hall on 6/16/18.
//  Copyright © 2018 Kevin Hall. All rights reserved.
//

import Foundation
import CoreData
import CloudKit
import UIKit
import CloudCore
import Toast_Swift


class ModelFactory {
    
    let context = persistentContainer.viewContext

    func save(date: Date, content: String, image: UIImage) {
        let entity = NSEntityDescription.entity(forEntityName: "Entries", in: context)!
        let entry = NSManagedObject(entity: entity, insertInto: context)
//
//        let documentsDirectoryPath:NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
//        var imageURL: URL!
//        let tempImageName = "Image2.jpg"
        
//
//        let imageData:Data = UIImageJPEGRepresentation(image, 1.0)!
//        let path:String = documentsDirectoryPath.appendingPathComponent(tempImageName)
//        try? UIImageJPEGRepresentation(image, 1.0)!.write(to: URL(fileURLWithPath: path), options: [.atomic])
//        imageURL = URL(fileURLWithPath: path)
//        try? imageData.write(to: imageURL, options: [.atomic])
//
//        let File:CKAsset?  = CKAsset(fileURL: URL(fileURLWithPath: path))
//        entry.setValue(File, forKey: "image")
        
        entry.setValue(false, forKey: "favorite")
        entry.setValue(date, forKey: "date")
        entry.setValue(content, forKeyPath: "content")
        entry.setValue(image.toData, forKey: "image")
//        entry.setValue(0.0, forKey: "locationLat")
//        entry.setValue(0.0, forKey: "locationLong")

        entries.append(entry)
        DispatchQueue.main.async {
            do {
                try self.context.save()
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
    }

    func updateData(_ newBody: String, newDate: Date, newimage: UIImage, entry: NSManagedObject){
        
        //let entry = entriesThisMonth[(gridCollectionView.indexPathsForSelectedItems?.first?.row)!]
        
        entry.setValue(newBody, forKey: "content")
        entry.setValue(newDate, forKey: "date")
        entry.setValue(newimage.toData, forKey: "image")
        
        DispatchQueue.main.async {
            self.context.refresh(entry, mergeChanges: true)
            do {
                try self.context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
    }
    
    
    func updateFavorite(favorite: Bool, entry: NSManagedObject, v: UIView){
        
        //let entry = entriesThisMonth[(gridCollectionView.indexPathsForSelectedItems?.first?.row)!]
        
        entry.setValue(favorite, forKey: "favorite")
        
        DispatchQueue.main.async {
            self.context.refresh(entry, mergeChanges: true)
            do {
                try self.context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
        if favorite {
            var style = ToastStyle()
            style.titleColor = COLOR_TEXT
            style.messageColor = COLOR_TEXT
            style.backgroundColor = UIColor.clear
            style.cornerRadius = 5
            style.fadeDuration = 1
            style.messageAlignment = .center
            style.titleAlignment = .center
            style.horizontalPadding = 0
            style.verticalPadding = 0

            let image = UIImage(named: "star")!.withRenderingMode(.alwaysTemplate)
            
            
            
            // toast presented with multiple options and with a completion closure
            v.makeToast("", duration: 1, point: CGPoint(x: v.frame.width/2, y: v.frame.height/2), title: "", image: image.imageWithColor(color1: COLOR_TEXT), style: style) { didTap in
                if didTap {
                    v.hideAllToasts()
                }
            }
        }
        
    }
    

//    func updateImage(image: UIImage){
//        let context = persistentContainer.viewContext
//
//        entries[entries.count-1-0].setValue(image.toData, forKey: "image")
//
//        do {
//            try context.save()
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
//    }
    
}




extension UIImage {
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
