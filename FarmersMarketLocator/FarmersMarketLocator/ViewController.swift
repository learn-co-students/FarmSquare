//
//  ViewController.swift
//  test
//
//  Created by Magfurul Abeer on 4/12/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {

    @IBOutlet weak var vineButton: UIButton!
    
    var blurEffectView: UIVisualEffectView? = nil
    var vineImageView: UIImageView? = nil
    var vineOutline: UIImageView? = nil
    var menuShown: Bool = false
    
    var basket: UIImageView? = nil
    var animator: UIDynamicAnimator? = nil
    var gravity: UIGravityBehavior? = nil
    var collision: UICollisionBehavior? = nil
    
    var fruits = [UIImageView]()
    var bottomBarrier = UIView()
    var leftBarrier = UIView()
    var rightBarrier = UIView()
    
    var timer = NSTimer()
    
    let fruitImages = [UIImage(named: "apple"), UIImage(named: "orange"), UIImage(named: "banana"), UIImage(named: "broccoli"), UIImage(named: "watermelon"), UIImage(named: "artichoke")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let value: Double = ((20 * M_PI)/180.0)
        let degrees: CGFloat = CGFloat(value)
        self.vineButton.transform = CGAffineTransformMakeRotation(degrees)
        
        createBlurView()
        
        self.performSelector("showLoadingScreen", withObject: nil, afterDelay: 3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func vineButtonTapped(sender: UIButton) {
        self.menuShown = true
        self.view.addSubview(blurEffectView!)
        self.vineButton.hidden = true
        addVineImage()
        showVineImage()
    }
    

    func emptySpaceTapped() {
        if self.basket != nil {
            hideLoadingScreen()
        } else {
            if self.vineOutline == nil {
                self.menuShown = false
            } else {
                self.vineOutline!.alpha = 0
            }
            self.vineImageView?.alpha = 1
            
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.vineImageView!.transform = CGAffineTransformMakeTranslation(0, 100)
                }) { (bool) -> Void in
                    
                    UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                        let value: Double = ((20 * M_PI)/180.0)
                        let degrees: CGFloat = CGFloat(value)
                        self.vineImageView!.transform = CGAffineTransformMakeRotation(degrees)
                        
                        }) { (bool) -> Void in
                            
                            self.vineOutline?.removeFromSuperview()
                            self.vineImageView?.removeFromSuperview()
                            self.blurEffectView?.removeFromSuperview()
                            self.vineButton.hidden = false
                    }
                    
            }
        }
        
    }
    
    
    // MARK: Helper Methods 
    
    func createBlurView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView!.frame = self.view.bounds
        blurEffectView!.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "emptySpaceTapped")
        blurEffectView?.addGestureRecognizer(tapGesture)
    }
    
    func addVineImage() {
        let image = UIImage(named: "VineSolid")
        vineImageView =  UIImageView(frame: CGRectMake(20, -418, 163, 490))
        vineImageView!.image = image
        self.view.addSubview(vineImageView!)
        
        let value: Double = ((20 * M_PI)/180.0)
        let degrees: CGFloat = CGFloat(value)
        vineImageView!.transform = CGAffineTransformMakeRotation(degrees)
    }
    
    func showVineImage() {
        
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.vineImageView!.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, 418), CGAffineTransformIdentity)
            
            }) { (bool) -> Void in
                self.showButtons()
        }
    }
    
    func showButtons() {
    //        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside
        
        vineOutline = UIImageView(frame: CGRectMake(20, 0, 163, 490))
        vineOutline!.image = UIImage(named: "VineOutline")
        vineOutline!.alpha = 0
        
        let mapButton = UIButton(type: UIButtonType.Custom) as UIButton
        mapButton.frame = CGRectMake(67, 70, 50, 50)
        let mapImage = UIImage(named: "mappin")
        mapButton.setImage(mapImage, forState: UIControlState.Normal)
        vineOutline!.addSubview(mapButton)
        
        let groceryButton = UIButton(type: UIButtonType.Custom) as UIButton
        groceryButton.frame = CGRectMake(60, 185, 50, 50)
        let groceryImage = UIImage(named: "cart")
        groceryButton.setImage(groceryImage, forState: UIControlState.Normal)
        vineOutline!.addSubview(groceryButton)
        
        let resourceButton = UIButton(type: UIButtonType.Custom) as UIButton
        resourceButton.frame = CGRectMake(70, 300, 50, 50)
        let resourceImage = UIImage(named: "book")
        resourceButton.setImage(resourceImage, forState: UIControlState.Normal)
        vineOutline!.addSubview(resourceButton)
        
        
        let searchButton = UIButton(type: UIButtonType.Custom) as UIButton
        searchButton.frame = CGRectMake(70, 420, 50, 50)
        let searchImage = UIImage(named: "dog")
        searchButton.setImage(searchImage, forState: UIControlState.Normal)
        vineOutline!.addSubview(searchButton)
        
        
        self.view.addSubview(vineOutline!)
        
        UIView.animateWithDuration(0.2) { () -> Void in
            self.vineOutline!.alpha = 1
            self.vineImageView?.alpha = 0
        }
    }
    
    
    func showLoadingScreen() {
        view.addSubview(self.blurEffectView!)
        
        
        basket = UIImageView(frame: CGRectMake(self.view.bounds.size.width/2 - 100, 3 * self.view.bounds.height/4 - 100, 200, 200))
        basket!.image = UIImage(named: "basket")
        basket?.layer.zPosition = 1
        self.view.addSubview(basket!)
        
        bottomBarrier = UIView(frame: CGRectMake(basket!.frame.origin.x, basket!.frame.origin.y + basket!.frame.size.height - 5, basket!.frame.size.width, 20))
        bottomBarrier.backgroundColor = UIColor.clearColor()
        view!.addSubview(bottomBarrier)
        leftBarrier = UIView(frame: CGRectMake(basket!.frame.origin.x, basket!.frame.origin.y, 20, basket!.frame.size.height))
        leftBarrier.backgroundColor = UIColor.clearColor()
        view!.addSubview(leftBarrier)
        rightBarrier = UIView(frame: CGRectMake(basket!.frame.origin.x + basket!.frame.size.width - 10, basket!.frame.origin.y, 20, basket!.frame.size.height))
        rightBarrier.backgroundColor = UIColor.clearColor()
        view!.addSubview(rightBarrier)
        
        
        animator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior(items: [])
        animator!.addBehavior(gravity!)
        collision = UICollisionBehavior(items: [])
        animator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [])
        animator!.addBehavior(gravity!)
        collision = UICollisionBehavior(items: [])
        collision!.addBoundaryWithIdentifier("leftBarrier", forPath: UIBezierPath(rect: bottomBarrier.frame))
        collision!.addBoundaryWithIdentifier("rightBarrier", forPath: UIBezierPath(rect: bottomBarrier.frame))
        collision!.addBoundaryWithIdentifier("bottomBarrier", forPath: UIBezierPath(rect: bottomBarrier.frame))
        animator!.addBehavior(collision!)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "dropApple", userInfo: nil, repeats: true)
        timer.fire()

    }
    
    func dropApple() {
        let random = Int(arc4random_uniform(UInt32(basket!.frame.size.width))) - Int(basket!.frame.width/2)
        let apple = UIImageView(frame: CGRectMake(self.view.bounds.size.width/2 + CGFloat(random), self.view.bounds.height/4, 45, 45))
        
        let num: Int = Int(arc4random_uniform(UInt32(self.fruitImages.count)))
        let randomFruit = self.fruitImages[num]
        apple.image = randomFruit;
        self.view.addSubview(apple)
        self.fruits.append(apple)
        
        gravity?.addItem(apple)
        collision?.addItem(apple)
        
        
        
        
        
        
        
    }
    
    func hideLoadingScreen() {
        self.timer.invalidate()
        self.blurEffectView?.removeFromSuperview()
        self.basket?.removeFromSuperview()
        self.basket = nil
        self.collision = nil
        self.gravity = nil
        self.animator = nil
        for fruit in fruits {
            fruit.removeFromSuperview()
        }
    }
    
    
}
