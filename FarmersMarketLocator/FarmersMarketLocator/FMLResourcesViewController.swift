//
//  FMLResourcesViewController.swift
//  FarmersMarketLocator
//
//  Created by Magfurul Abeer on 4/20/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

import UIKit

class FMLResourcesViewController: UIViewController {
    
    let webView = UIWebView()
    
    override func viewDidLoad() {
//        NSUserDefaults.standardUserDefaults()
        self.view.backgroundColor = UIColor.blackColor()
        webView.backgroundColor = UIColor.redColor()
        self.view.addSubview(webView)
        webView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        }
        let request = NSURLRequest(URL: NSURL(string: "http://www.fns.usda.gov/snap/supplemental-nutrition-assistance-program-snap")!)
        webView.loadRequest(request)
    }
}
