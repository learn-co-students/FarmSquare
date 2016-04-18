//
//  BookViewController.swift
//  FarmersMarketLocator
//
//  Created by Magfurul Abeer on 4/14/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bookImage = UIImage(named: "book")
        let imageView = UIImageView(image: bookImage)
        self.view.addSubview(imageView)
        imageView.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
}
