//
//  FMLSwitchCell.swift
//  FarmersMarketLocator
//
//  Created by Magfurul Abeer on 4/21/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

import UIKit

class FMLSwitchCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    var block: ((isOn: Bool) -> ())?
    
    @IBAction func switchValueChanged(sender: UISwitch) {
        block!(isOn: sender.on)
    }
    
    
    
}
