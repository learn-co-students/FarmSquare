//
//  FMLDisclaimerVC.swift
//  FarmersMarketLocator
//
//  Created by Jeff Spingeld on 4/20/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

import UIKit

class FMLDisclaimerVC: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Transparent yellow background
        view.backgroundColor = UIColor.yellowColor()
        
        // Textview with disclaimer
        let textView = UITextView()
        
        textView.backgroundColor = UIColor(colorLiteralRed: 118/255.0, green: 78/255.0, blue: 47/255.0, alpha: 1)
        textView.textColor = UIColor.whiteColor()
        
        let disclaimerString = "Disclaimer:\n\nThe information presented in this app is provided by the USDA and we can’t guarantee it being fully accurate and up-to-date.\n\nThis app has been a joint project by Magfurul Abeer, Julia Geist, Jeffrey Spingeld and Slobodan Kovrlija.\n\nFarmsquare has been developed with the support of Opportunity Project, a White House initiative for open data, aimed towards improving economic mobility for all Americans."
        textView.text = disclaimerString
        view.addSubview(textView)
        
        
        // Turn off autoresizing mask
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        // Size textview
        textView.heightAnchor.constraintEqualToAnchor(view.heightAnchor, multiplier: 0.5, constant: 0).active = true
        textView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, multiplier: 1).active = true
        textView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        textView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        

        let button = UIButton(type: UIButtonType.Custom)
        button.addTarget(self, action: #selector(FMLDisclaimerVC.dismissSelf), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        button.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
//        let imageName = "Icon-83.5@2x.png"
//        let image = UIImage(named: imageName)
//        let imageView = UIImageView(image: image!)
//        
//        imageView.heightAnchor.constraintEqualToConstant(100).active = true
//        imageView.widthAnchor.constraintEqualToConstant(100).active = true
//        imageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
//        imageView.topAnchor.constraintEqualToAnchor(textView.bottomAnchor, constant: 20)
//        view.addSubview(imageView)
        
    }
    
    func dismissSelf() {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }

}
