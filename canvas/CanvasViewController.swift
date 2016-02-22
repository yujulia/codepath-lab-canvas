//
//  ViewController.swift
//  canvas
//
//  Created by Julia Yu on 2/22/16.
//  Copyright © 2016 Julia Yu. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    
    var trayOriginalCenter: CGPoint?
    var trayIsOpen = true
    
    var trayCenterWhenClosed: CGPoint!
    var trayCenterWhenOpen: CGPoint!
    
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint?
    
    var landedFaceOriginalCenter: CGPoint?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.trayCenterWhenOpen = self.trayView.center
        self.trayCenterWhenClosed = CGPoint(x: self.view.center.x, y: self.view.frame.size.height + (self.trayView.frame.size.height / 2) - 30)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func toggleTrayView() {
        var toPoint: CGPoint
        if self.trayIsOpen {
            toPoint = self.trayCenterWhenClosed
        } else {
            toPoint = self.trayCenterWhenOpen
        }
        self.animateTrayCenterToPoint(toPoint)
        self.trayIsOpen = !self.trayIsOpen
    }
    
    private func animateTrayCenterToPoint(point: CGPoint) {
        UIView.animateWithDuration(
            0.35,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0.35,
            options: .CurveEaseInOut,
            animations: { () -> Void in
                self.trayView.center = point
            },
            completion: nil
        )
    }
    
    @IBAction func onTapGesture(tapGestureRecognizer: UITapGestureRecognizer) {
        self.toggleTrayView()
    }
    
    @IBAction func onTrayPanGesture(panGestureRecognizer: UIPanGestureRecognizer) {
        // Relative change in (x,y) coordinates from where gesture began.
        let translation = panGestureRecognizer.translationInView(view)
        let velocity = panGestureRecognizer.velocityInView(view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            trayOriginalCenter = trayView.center
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            let newTrayCenterY = translation.y + trayOriginalCenter!.y
            trayView.center.y = newTrayCenterY < self.trayCenterWhenOpen.y ? self.trayCenterWhenOpen.y : newTrayCenterY            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            if velocity.y < 0 {
                self.animateTrayCenterToPoint(self.trayCenterWhenOpen)
                self.trayIsOpen = true
            } else {
                self.animateTrayCenterToPoint(self.trayCenterWhenClosed)
                self.trayIsOpen = false
            }
        }
    }
    
    func onNewSmileyPan(panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translationInView(view)
        
        let mySmileyView = panGestureRecognizer.view
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {

            self.landedFaceOriginalCenter = mySmileyView!.center
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            
            mySmileyView!.center = CGPoint(
                x: self.landedFaceOriginalCenter!.x + translation.x,
                y: self.landedFaceOriginalCenter!.y + translation.y
            )
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {

        }
    }
    
    func onPinchSmiley(pinchGestureRecognizer: UIPinchGestureRecognizer) {
        let mySmileyView = pinchGestureRecognizer.view
        
        if pinchGestureRecognizer.state == UIGestureRecognizerState.Began {
     
            
        } else if pinchGestureRecognizer.state == UIGestureRecognizerState.Changed {
            let scale = pinchGestureRecognizer.scale / log(pinchGestureRecognizer.scale)
            mySmileyView!.transform = CGAffineTransformScale(mySmileyView!.transform, scale, scale)

        } else if pinchGestureRecognizer.state == UIGestureRecognizerState.Ended {
            
        }
    }
    
    func onRotateSmiley(rotateGestureRecognizer: UIRotationGestureRecognizer) {
        let mySmileyView = rotateGestureRecognizer.view
        
        if rotateGestureRecognizer.state == UIGestureRecognizerState.Began {
            
            
        } else if rotateGestureRecognizer.state == UIGestureRecognizerState.Changed {
            print("rotate changed")
            
            mySmileyView!.transform = CGAffineTransformRotate(mySmileyView!.transform, CGFloat(rotateGestureRecognizer.rotation * CGFloat(M_PI) / CGFloat(180)))
            
        } else if rotateGestureRecognizer.state == UIGestureRecognizerState.Ended {
            
        }
    }
    
    @IBAction func onSmileyPanGesture(panGestureRecognizer: UIPanGestureRecognizer) {
        // Relative change in (x,y) coordinates from where gesture began.
        let translation = panGestureRecognizer.translationInView(view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            
            let imageView = panGestureRecognizer.view as! UIImageView
            self.newlyCreatedFace = UIImageView(image: imageView.image)
            self.view.addSubview(self.newlyCreatedFace)
            self.newlyCreatedFace.center = imageView.center
            self.newlyCreatedFace.center.y += self.trayView.frame.origin.y
            self.newlyCreatedFaceOriginalCenter = self.newlyCreatedFace.center
            
            let newGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onNewSmileyPan:")
            self.newlyCreatedFace.addGestureRecognizer(newGestureRecognizer)
            self.newlyCreatedFace.userInteractionEnabled = true
            
            newlyCreatedFace.transform = CGAffineTransformMakeScale(1.5, 1.5)
            
            let newPinchRecognizer = UIPinchGestureRecognizer(target: self, action: "onPinchSmiley:")
            self.newlyCreatedFace.addGestureRecognizer(newPinchRecognizer)
            
            let newRotateRecognizer = UIRotationGestureRecognizer(target: self, action: "onRotateSmiley:")
            self.newlyCreatedFace.addGestureRecognizer(newRotateRecognizer)
            
            newPinchRecognizer.delegate = self
            
            
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            self.newlyCreatedFace.center = CGPoint(
                x: self.newlyCreatedFaceOriginalCenter!.x + translation.x,
                y: self.newlyCreatedFaceOriginalCenter!.y + translation.y
            )
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            self.newlyCreatedFace.transform = CGAffineTransformMakeScale(1, 1)
        }
    }

}

extension CanvasViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
