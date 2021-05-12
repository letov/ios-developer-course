//
//  UIViewAnimationController.swift
//  Course2Week4Task2
//
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

class UIViewAnimationController: UIViewController {
    
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var flipButton: UIButton!
    
    @IBAction func animationViewTapHandler(sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 1,
                       delay: 0.5,
                       options: [.curveEaseInOut],
                       animations: {
                        self.animationView.center = CGPoint(x: self.view.frame.width - self.animationView.center.x, y: self.animationView.center.y)
                        let endAngle: CGFloat = 180 * CGFloat.pi / 180
                        self.animationView.transform = CGAffineTransform(rotationAngle: endAngle)
                       },
                       completion: nil)
    }
    
    @IBAction func flipButtonTapHandler(sender: UIButton) {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: {
                        let angle: CGFloat = atan2(self.view.transform.b,self.view.transform.a) == 0 ? 180 : 0
                        let endAngle: CGFloat = angle * CGFloat.pi / 180
                        self.view.transform = CGAffineTransform(rotationAngle: endAngle)
                        self.flipButton.transform = CGAffineTransform(rotationAngle: endAngle)
                       },
                       completion: nil)
    }
}
