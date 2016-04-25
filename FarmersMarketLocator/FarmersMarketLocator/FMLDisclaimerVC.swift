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
        view.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.5)
        
        // Textview with disclaimer
        let textView = UITextView()
        textView.backgroundColor = UIColor(colorLiteralRed: 118/255.0, green: 78/255.0, blue: 47/255.0, alpha: 1)
        textView.textColor = UIColor.whiteColor()
        let disclaimerString = "Disclaimer:\n\nThe information presented in this app is provided by the USDA and we can't guarantee that it's always accurate or up-to-date. Sorry!"
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
        button.addTarget(self, action: "dismissSelf", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        button.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    func dismissSelf() {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }

}
