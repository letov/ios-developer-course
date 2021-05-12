//
//  ViewController.swift
//  Course2Week4Task2
//
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

class CABasicAnimationController: UIViewController {
    
    @IBOutlet weak var orangeView: UIView!
    @IBOutlet weak var cyanView: UIView!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var greenView: UIView!
    
    override func viewDidLoad() {
        self.orangeView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(self.orangeAnimation(sender:)))
        )
        
        self.cyanView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(self.cyanAnimation(sender:)))
        )
        
        self.blueView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(self.blueAnimation(sender:)))
        )
        
        self.greenView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(self.greenAnimation(sender:)))
        )
    }
    
    @objc func orangeAnimation(sender: UITapGestureRecognizer){
        let radius = self.orangeView.frame.size.width / 2
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.cornerRadius))
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.duration = 1.0
        animation.fromValue = 0
        animation.toValue = radius
        self.orangeView.layer.add(animation, forKey: "orangeAnimation")
        self.orangeView.layer.cornerRadius = radius
    }
    
    @objc func cyanAnimation(sender: UITapGestureRecognizer){
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation.duration = 1.0
        animation.fromValue = 1.0
        animation.toValue = 0
        self.cyanView.layer.add(animation, forKey: "cyanAnimation")
        self.cyanView.layer.opacity = 0
    }
    
    @objc func blueAnimation(sender: UITapGestureRecognizer){
        let endPoint = CGPoint(x: self.cyanView.center.x, y: self.blueView.center.y)
        let animationPosition = CABasicAnimation(keyPath: #keyPath(CALayer.position))
        animationPosition.fromValue = self.blueView.center
        animationPosition.toValue = endPoint

        let endAngle: CGFloat = 315.0 * CGFloat.pi / 180
        let animationRotate = CABasicAnimation(keyPath: "transform.rotation.z")
        animationRotate.fromValue = 0
        animationRotate.toValue = endAngle
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [animationPosition, animationRotate]
        groupAnimation.duration = 2.0
        groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        self.blueView.layer.add(groupAnimation, forKey: "groupBlueAnimation")
        
        self.blueView.layer.position = endPoint
        self.blueView.layer.transform = CATransform3DMakeRotation(endAngle, 0, 0, 1)
    }
    
    @objc func greenAnimation(sender: UITapGestureRecognizer){
        let endPoint = self.view.center
        let animationPosition = CABasicAnimation(keyPath: #keyPath(CALayer.position))
        animationPosition.fromValue = self.greenView.center
        animationPosition.toValue = endPoint

        let animationScale = CABasicAnimation(keyPath: "transform.scale")
        animationScale.fromValue = 1.0
        animationScale.toValue = 1.5
        
        let animationColor = CABasicAnimation(keyPath: #keyPath(CALayer.backgroundColor))
        animationColor.fromValue = UIColor.green.cgColor
        animationColor.toValue = UIColor.magenta.cgColor
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [animationPosition, animationScale, animationColor]
        groupAnimation.duration = 1.0
        groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        groupAnimation.autoreverses = true
        groupAnimation.repeatCount = 2.0
        self.greenView.layer.add(groupAnimation, forKey: "groupGreenAnimation")
        
        self.greenView.layer.position = self.greenView.center
        self.greenView.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
        self.greenView.layer.backgroundColor = UIColor.green.cgColor
    }
}
