//
//  UIViewPropertyAnimatorController.swift
//  Course2Week4Task2
//
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

class UIViewPropertyAnimatorController: UIViewController {
    
    @IBOutlet weak var animationView: UIView!
    private var animator: UIViewPropertyAnimator!
    
    @IBAction func panGestureHandler(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            let timingParameters = UISpringTimingParameters(mass: 2.0,
                                                            stiffness: 30.0,
                                                            damping: 7.0,
                                                            initialVelocity: .zero)
            animator = UIViewPropertyAnimator(duration: 1, timingParameters: timingParameters)
            animator.addAnimations {
                self.animationView.center.x += 300
                self.animationView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                                    .concatenating( CGAffineTransform(scaleX: 1.5, y: 1.5))
            }
        case .changed:
            animator.fractionComplete = recognizer.translation(in: view).x / self.view.bounds.size.width
        case .ended:
            if let xPos = self.animationView.layer.presentation()?.position.x {
                animator.isReversed = xPos <= self.view.bounds.size.width / 2
            }
            animator.startAnimation()
        default:
            ()
        }
    }
}
