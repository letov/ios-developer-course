//
//  CATransitionController.swift
//  Course2Week4Task2
//
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

class CATransitionController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!

    @IBAction func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        CATransaction.begin()

        CATransaction.setCompletionBlock {
            let animationReverse = CATransition()
            animationReverse.duration = 1
            animationReverse.type = .fade
            animationReverse.timingFunction = CAMediaTimingFunction(name: .easeOut)
            self.textLabel.layer.add(animationReverse, forKey: "animationReverse")
            self.textLabel.text = "Inital text"
            self.textLabel.textColor = .orange
        }
        
        let animation = CATransition()
        animation.duration = 1
        animation.type = .moveIn
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        self.textLabel.layer.add(animation, forKey: "animation")
        self.textLabel.text = "Sliding!"
        self.textLabel.textColor = .green
                
        CATransaction.commit()
    }

}
