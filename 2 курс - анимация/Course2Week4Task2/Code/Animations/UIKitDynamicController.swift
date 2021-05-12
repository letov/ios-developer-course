//
//  UIKitDynamicController.swift
//  Course2Week4Task2
//
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

class UIKitDynamicController: UIViewController {
    
    @IBOutlet weak var anchorView: UIView!
    @IBOutlet weak var animationView: UIView!
    
    var attachment: UIAttachmentBehavior!
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    
    var panGesture: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panning(sender:)))
        self.anchorView.addGestureRecognizer(panGesture)
        
        attachment = UIAttachmentBehavior(item: self.animationView,
                                          attachedToAnchor: anchorView.center)
        
        animator = UIDynamicAnimator(referenceView: self.view)
        animator.addBehavior(attachment)
        
        gravity = UIGravityBehavior(items: [self.animationView])
        animator.addBehavior(gravity)
    }
    
    @objc func panning(sender: UIPanGestureRecognizer) {
        self.anchorView.center = sender.location(in: self.view)
        self.animator.removeBehavior(attachment)
        attachment = UIAttachmentBehavior(item: self.animationView,
                                          attachedToAnchor: anchorView.center)
        animator.addBehavior(attachment)
    }
    
}
