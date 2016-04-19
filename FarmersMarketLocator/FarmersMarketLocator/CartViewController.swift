//
//  CartViewController.swift
//  FarmersMarketLocator
//
//  Created by Magfurul Abeer on 4/14/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cartImage = UIImage(named: "cart")
        let imageView = UIImageView(image: cartImage)
        self.view.addSubview(imageView)
        imageView.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
}
