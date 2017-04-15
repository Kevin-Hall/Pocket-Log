//
//  EditorVC.swift
//  Journal
//
//  Created by Kevin Hall on 4/2/17.
//  Copyright © 2017 Kevin Hall. All rights reserved.
//
import UIKit

class EditorVC: UIViewController {
    
    var image = UIImage() // image to display
    
    @IBOutlet weak var doneBtn : UIButton?
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: false) {
        }
    }
    
    let maskLayer = CAShapeLayer()
    var path = UIBezierPath()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.imageView.image = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the mask
        path = UIBezierPath(roundedRect:self.view.bounds,byRoundingCorners:[.allCorners],cornerRadii: CGSize(width: 30 ,height: 250))
        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.path = path.cgPath
        
        //view looks
        self.view.layer.mask = maskLayer
        self.view.backgroundColor = UIColor.black
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
