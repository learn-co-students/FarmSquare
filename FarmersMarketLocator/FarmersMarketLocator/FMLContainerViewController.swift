//
//  FMLContainerViewController.swift
//  FarmersMarketLocator
//
//  Created by Magfurul Abeer on 4/13/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

import UIKit
import SnapKit

class FMLContainerViewController: UIViewController {
    
    let mapViewController = FMLMapViewController()

    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var vineButton: UIButton!

    
    var blurEffectView = UIVisualEffectView()
    var vineImageView = UIImageView()
    var vineOutline = UIImageView()
    var menuShown = false
    
    override func viewDidLoad() {
        self.setEmbeddedViewController(mapViewController)
        
        let value: Double = ((20 * M_PI)/180.0)
        let degrees: CGFloat = CGFloat(value)
        self.vineButton.transform = CGAffineTransformMakeRotation(degrees)
        
        createBlurView()
    }
    
    // MARK: Vine Menu Methods
    
    func createBlurView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        //always fill the view
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "emptySpaceTapped")
        blurEffectView.addGestureRecognizer(tapGesture)
    }
    
    
    // MARK: Gesture Methods
    
    // MARK: IBActions
    
    @IBAction func vineButtonTapped(sender: UIButton) {
        self.menuShown = true
        self.view.addSubview(blurEffectView)
        self.vineButton.hidden = true
        
        addVineImage()
        showVineImage()
    }
    
    func addVineImage() {
        let image = UIImage(named: "VineSolid")
        vineImageView =  UIImageView(frame: CGRectMake(20, -418, 163, 490))
        vineImageView.image = image
        self.view.addSubview(vineImageView)
        
        let value: Double = ((20 * M_PI)/180.0)
        let degrees: CGFloat = CGFloat(value)
        vineImageView.transform = CGAffineTransformMakeRotation(degrees)
    }
    
    func showVineImage() {
        
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.vineImageView.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, 418), CGAffineTransformIdentity)
            
        }) { (bool) -> Void in
            self.showButtons()
        }
    }
    
    func showButtons() {
        //        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside
        
        vineOutline = UIImageView(frame: CGRectMake(20, 0, 163, 490))
        vineOutline.image = UIImage(named: "VineOutline")
        vineOutline.alpha = 0
        
        let mapButton = UIButton(type: UIButtonType.Custom) as UIButton
        mapButton.frame = CGRectMake(67, 70, 50, 50)
        let mapImage = UIImage(named: "mappin")
        mapButton.setImage(mapImage, forState: UIControlState.Normal)
        vineOutline.addSubview(mapButton)
        
        let groceryButton = UIButton(type: UIButtonType.Custom) as UIButton
        groceryButton.frame = CGRectMake(60, 185, 50, 50)
        let groceryImage = UIImage(named: "cart")
        groceryButton.setImage(groceryImage, forState: UIControlState.Normal)
        vineOutline.addSubview(groceryButton)
        
        let resourceButton = UIButton(type: UIButtonType.Custom) as UIButton
        resourceButton.frame = CGRectMake(70, 300, 50, 50)
        let resourceImage = UIImage(named: "book")
        resourceButton.setImage(resourceImage, forState: UIControlState.Normal)
        vineOutline.addSubview(resourceButton)
        
        
        let searchButton = UIButton(type: UIButtonType.Custom) as UIButton
        searchButton.frame = CGRectMake(70, 420, 50, 50)
        let searchImage = UIImage(named: "dog")
        searchButton.setImage(searchImage, forState: UIControlState.Normal)
        vineOutline.addSubview(searchButton)
        
        
        self.view.addSubview(vineOutline)
        
        UIView.animateWithDuration(0.2) { () -> Void in
            self.vineOutline.alpha = 1
            self.vineImageView.alpha = 0
        }
    }
    
    func emptySpaceTapped() {
        
//        if self.vineOutline == nil {
//            self.menuShown = false
//        } else {
            self.vineOutline.alpha = 0
//        }
        self.vineImageView.alpha = 1
        
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.vineImageView.transform = CGAffineTransformMakeTranslation(0, 100)
        }) { (bool) -> Void in
            
            UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                let value: Double = ((20 * M_PI)/180.0)
                let degrees: CGFloat = CGFloat(value)
                self.vineImageView.transform = CGAffineTransformMakeRotation(degrees)
                
            }) { (bool) -> Void in
                
                self.vineOutline.removeFromSuperview()
                self.vineImageView.removeFromSuperview()
                self.blurEffectView.removeFromSuperview()
                self.vineButton.hidden = false
            }
            
        }
        
        
    }

    
    // MARK: Container View Handler Method
    
    // Thanks Tim Clem!
    func setEmbeddedViewController(controller: UIViewController?) {
        
        if self.childViewControllers.contains(controller!) {
            return
        }
        
        for vc in self.childViewControllers {
            
            if vc.isViewLoaded() {
                vc.view.removeFromSuperview()
            }
            
            vc.removeFromParentViewController()
        }
        
        if controller == nil {
            return
        }
        
        self.addChildViewController(controller!)
        self.containerView.addSubview(controller!.view)
        controller!.view.snp_updateConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        controller?.didMoveToParentViewController(self)
        
    }
}
