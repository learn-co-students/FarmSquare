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
        // Transparent yellow view
        let view = UIView()
        view.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false;
        view.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(0)
        }

        // Textview with disclaimer
        let textView = UITextView()
        let disclaimerString = "Disclaimer:\n\nThe information presented in this app is provided by the USDA and we can't guarantee that it's always accurate or up-to-date. Sorry!"
        textView.text = disclaimerString
        view.addSubview(textView)
        
        // Size textview
        let textviewHeight = textView.heightAnchor.constraintEqualToConstant(view.frame.height * 0.5)
        let textviewWidth = textView.widthAnchor.constraintEqualToConstant(view.frame.width)
        
        // Center textview vertically and horizontally in view
        let textviewXPosition = NSLayoutConstraint(item: textView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let textviewYPosition = NSLayoutConstraint(item: textView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        
        view.addConstraints([textviewXPosition, textviewYPosition, textviewHeight, textviewWidth])

    }

}
