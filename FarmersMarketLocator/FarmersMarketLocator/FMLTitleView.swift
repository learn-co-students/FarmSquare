//
//  FMLTitleView.swift
//  FarmersMarketLocator
//
//  Created by Magfurul Abeer on 4/15/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

import UIKit

@objc class FMLTitleView: UIView {
    
    let nameLabel = UILabel()
    let addressLabel = UILabel()
    let border = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.whiteColor()
        self.prepareLabels(self.nameLabel, text: "Sample Farmers Market Name", font: "Helvetica", size: 20)
        self.prepareLabels(self.addressLabel, text: "123 Some Street\nCity, ST 12345", font: "Helvetica", size: 16)
        self.addSubview(self.nameLabel)
        self.addSubview(self.addressLabel)
        
        self.setBorder()
        
        self.hideTitleView()
    }
    
    // Not sure why I need this or even how to implement it
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBorder() {
        let width = CGFloat(10.0)
        border.borderColor = UIColor(colorLiteralRed: 38/255.0, green: 89/255.0, blue: 15/255.0, alpha: 1.0).CGColor
        border.frame = CGRect(x: -width, y:  90, width: self.frame.size.width + 2*width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func prepareLabels(label: UILabel, text: String, font: String, size: Float) {
        label.text = text
        label.font = UIFont(name: font, size: CGFloat(size))
        label.textColor = UIColor.blackColor()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.Center
    }
    
    func constrainViews() {
        constrainToTop()
        constrainLabels()
    }
    
    func constrainToTop() {
        self.topAnchor.constraintEqualToAnchor(self.superview?.topAnchor).active = true
        self.leadingAnchor.constraintEqualToAnchor(self.superview?.leadingAnchor).active = true
        self.widthAnchor.constraintEqualToAnchor(self.superview?.widthAnchor).active = true
        self.heightAnchor.constraintEqualToConstant(100).active = true
    }
    
    func constrainLabels() {
        
        self.nameLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 10).active = true
        self.nameLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 10).active = true
        self.nameLabel.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 10).active = true
        
        self.addressLabel.topAnchor.constraintEqualToAnchor(self.nameLabel.bottomAnchor, constant: 10).active = true
        self.addressLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 10).active = true
        self.addressLabel.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 10).active = true
    }
    
    func showTitleView() {
        UIView.animateWithDuration(0.25) { 
            self.transform = CGAffineTransformIdentity
            self.border.hidden = false
        }
    }
    
    func hideTitleView() {
        UIView.animateWithDuration(0.25) { 
            self.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height - 20)
            self.border.hidden = true
        }
    }
    
}
