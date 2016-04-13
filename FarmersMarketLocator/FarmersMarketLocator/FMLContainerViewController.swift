//
//  FMLContainerViewController.swift
//  FarmersMarketLocator
//
//  Created by Magfurul Abeer on 4/13/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

import UIKit
import SnapKit

class FMLContainerViewController: UIViewController {
    
    let mapViewController = FMLMapViewController()

    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        self.setEmbeddedViewController(mapViewController)
    }
    
    // Thanks Tim
    func setEmbeddedViewController(controller: UIViewController?) {
        
        if self.childViewControllers.contains(controller!) {
            return
        }
        
        for vc in self.childViewControllers {
            
            if vc.isViewLoaded() {
                vc.view.removeFromSuperview()
            }
            
            vc.removeFromParentViewController()
        }
        
        if controller == nil {
            return
        }
        
        self.addChildViewController(controller!)
        self.containerView.addSubview(controller!.view)
        controller!.view.snp_updateConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        controller?.didMoveToParentViewController(self)
        
    }
}

/*
-(void)setEmbeddedViewController:(UIViewController *)controller
{
    if([self.childViewControllers containsObject:controller]) {
        return;
    }
    
    for(UIViewController *vc in self.childViewControllers) {
        [vc willMoveToParentViewController:nil];
        
        if(vc.isViewLoaded) {
            [vc.view removeFromSuperview];
        }
        
        [vc removeFromParentViewController];
    }
    
    if(!controller) {
        return;
    }
    
    [self addChildViewController:controller];
    [self.containerView addSubview:controller.view];
    [controller.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
        }];
    [controller didMoveToParentViewController:self];
}
 */