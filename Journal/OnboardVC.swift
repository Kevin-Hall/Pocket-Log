//
//  OnboardVC.swift
//  Journal
//
//  Created by Kevin Hall on 7/13/18.
//  Copyright © 2018 Kevin Hall. All rights reserved.
//

import Foundation
import UIKit


class OnboardVC: UIViewController , CAAnimationDelegate{
    
    let impactFeedbackGenerator: (
        light: UIImpactFeedbackGenerator,
        medium: UIImpactFeedbackGenerator,
        heavy: UIImpactFeedbackGenerator) = (
            UIImpactFeedbackGenerator(style: .light),
            UIImpactFeedbackGenerator(style: .medium),
            UIImpactFeedbackGenerator(style: .heavy)
    )

    
    var curr = 0
    let gradient = CAGradientLayer()
    public var gradientSet = [[CGColor]]()
    
//    let g1 = UIColor(rgb: 0x00E2E8).cgColor
//    let g2 = UIColor(rgb: 0x4643FF).cgColor
//    let g3 = UIColor(rgb: 0xFE09AD).cgColor
//    let g4 = UIColor(rgb: 0xFFA415).cgColor
//    let g5 = UIColor(rgb: 0xFFFF00).cgColor
    
//    let g1 = UIColor(rgb: 0x3439D8).cgColor
//    let g2 = UIColor(rgb: 0xBF34FB).cgColor
    
    let g1 = UIColor(rgb: 0x00E2E8).cgColor
    let g2 = UIColor(rgb: 0x4643FF).cgColor
    let g3 = UIColor(rgb: 0xFE09AD).cgColor
    let g4 = UIColor(rgb: 0xFFA415).cgColor


    func animateGradient() {
        if curr < gradientSet.count - 1 {
            curr += 1
        } else {
            curr = 0
        }
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.delegate = self
        gradientChangeAnimation.duration = 6.0
        gradientChangeAnimation.toValue = gradientSet[curr]
        gradientChangeAnimation.fillMode = kCAFillModeForwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradient.add(gradientChangeAnimation, forKey: "colorChange")
        
        
    }
    
    @IBOutlet weak var ContinueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Prepare shortly before playing
        impactFeedbackGenerator.light.prepare()
        impactFeedbackGenerator.medium.prepare()
        impactFeedbackGenerator.heavy.prepare()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("did appear")
        
        ContinueButton.layer.cornerRadius = 5
        ContinueButton.clipsToBounds = true
        ContinueButton.backgroundColor = UIColor.red
        
        gradientSet.append([g1, g2])
        gradientSet.append([g2, g3])
        gradientSet.append([g3, g4])
        gradientSet.append([g4, g1])
        
        gradient.frame = ContinueButton.bounds
        gradient.colors = gradientSet[curr]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        gradient.drawsAsynchronously = true
        animateGradient()
        
        ContinueButton.layer.insertSublayer(gradient, at: 0)
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[curr]
            animateGradient()
        }
    }
    
    @IBAction func continueAction(_ sender: Any) {

        
        impactFeedbackGenerator.medium.impactOccurred()
        
        UserDefaults.standard.set(true, forKey: "ONBOARDING")

        
        self.dismiss(animated: true) {
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
