//
//  DogViewController.swift
//  FarmersMarketLocator
//
//  Created by Magfurul Abeer on 4/14/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

import UIKit
import SnapKit

class DogViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dogImage = UIImage(named: "dog")
        let imageView = UIImageView(image: dogImage)
        self.view.addSubview(imageView)
        imageView.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }

}
