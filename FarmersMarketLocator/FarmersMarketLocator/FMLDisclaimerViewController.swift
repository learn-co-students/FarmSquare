//
//  FMLDisclaimerViewController.swift
//  FarmersMarketLocator
//
//  Created by Magfurul Abeer on 4/25/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

import UIKit
import WebKit

class FMLDisclaimerViewController: UIViewController {
    
    let webView = WKWebView()
    var url = NSURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismissButton = UIButton(type: UIButtonType.Custom)
        dismissButton.setTitle("Close", forState: UIControlState.Normal)
        dismissButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        dismissButton.backgroundColor = UIColor(colorLiteralRed: 38/255.0, green: 89/255.0, blue: 15/255.0, alpha: 1.0)
        dismissButton.addTarget(self, action: #selector(dismiss), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(dismissButton)
        dismissButton.snp_makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(50)
        }
        
        
        self.view.addSubview(webView)
        webView.snp_makeConstraints { (make) in
            make.top.equalTo(dismissButton.snp_bottom)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        webView.loadFileURL(url, allowingReadAccessToURL: url)
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: {
            
        })
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
