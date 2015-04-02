//
//  ViewController.swift
//  SideMenu
//
//  Created by Mohamed Said on 4/2/15.
//  Copyright (c) 2015 Mohamed Said. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    var sideMenu: UIView!
    var screenImageView: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func captureScreen() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, view.opaque, 0.0)
        view.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image;
    }
    
    func closeMenu(sender: UIImageView){
        
        UIView.animateKeyframesWithDuration(1, delay: 0, options: nil, animations: {
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 2/3, animations: {
                self.sideMenu.alpha = 0
                self.sideMenu.frame.origin.y = -10
            })
            
            UIView.addKeyframeWithRelativeStartTime(1/3, relativeDuration: 2/3, animations: {
                self.screenImageView.layer.transform = CATransform3DIdentity
                self.screenImageView.frame.size = self.view.frame.size
                self.screenImageView.frame.origin = CGPointMake(0, 0)
            })
            
            },
            completion: {_ in
                self.screenImageView.removeFromSuperview()
                self.sideMenu.removeFromSuperview()
                
                for subView in self.view.subviews as [UIView]{
                    if subView.tag < 2000{
                        subView.hidden = false
                    }
                }
            }
        )
    }
    
    @IBAction func showMenu(sender: UIButton) {
        // Add the background image to the main view
        UIGraphicsBeginImageContext(self.view.frame.size);
        UIImage(named: "splashBG")!.drawInRect(self.view.bounds)
        var backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        view.backgroundColor = UIColor(patternImage: backgroundImage!)
        
        // Capture the current screen
        screenImageView = UIImageView(image: captureScreen())
        screenImageView.tag = 2001
        view.addSubview(screenImageView)
        
        // Initiate Gesture recognizer
        let recognizer = UITapGestureRecognizer(target: self, action: "closeMenu:")
        view.addGestureRecognizer(recognizer)
        
        // Build the menu from a Nib and add it as a sub view
        sideMenu = NSBundle.mainBundle().loadNibNamed("SideMenu", owner: self, options: nil)[0] as UIView
        sideMenu.tag = 2002
        sideMenu.alpha = 0
        sideMenu.frame.origin.y = -10
        view.addSubview(sideMenu)
        
        // Hide all other subviews
        for subView in view.subviews as [UIView]{
            if subView.tag < 2000{
                subView.hidden = true
            }
        }
        
        // Animate the captured image
        var id = CATransform3DIdentity
        id.m34 =  -1.0 / 1000
        
        let rotationTransform = CATransform3DRotate(id, 0.5 * CGFloat(-M_PI_2), 0, 1.0, 0)
        let translationTransform = CATransform3DMakeTranslation(screenImageView.frame.width * 0.2, 0, 0)
        let transform = CATransform3DConcat(rotationTransform, translationTransform)
        
        UIView.animateKeyframesWithDuration(1, delay: 0, options: nil, animations: {
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1/3, animations: {
                self.screenImageView.layer.transform = transform
                self.screenImageView.frame.size.height -= 200
                self.screenImageView.center.y += 100
            })
            
            UIView.addKeyframeWithRelativeStartTime(1/3, relativeDuration: 2/3, animations: {
                self.sideMenu.alpha = 1
                self.sideMenu.frame.origin.y = 0
            })
            
            },
            completion: {_ in}
        )
        
    }
}

