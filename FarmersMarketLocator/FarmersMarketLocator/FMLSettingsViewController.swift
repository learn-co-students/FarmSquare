//
//  FMLSettingsViewController.swift
//  FarmersMarketLocator
//
//  Created by Magfurul Abeer on 4/21/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

import UIKit

class FMLSettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        self.automaticallyAdjustsScrollViewInsets = true
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: FMLSwitchCell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! FMLSwitchCell
            cell.titleLabel.text = "Automatically Save Pins"
            cell.switchButton.on = !NSUserDefaults.standardUserDefaults().boolForKey("CoreDataTurnedOff")
            cell.block = { (isOn: Bool) -> () in
                NSUserDefaults.standardUserDefaults().setBool(isOn, forKey: "CoreDataTurnedOff")
            }

            return cell
        }
        
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("RightDetail", forIndexPath: indexPath)
            cell.textLabel?.text = "Clear Saved Pins"
            cell.detailTextLabel?.text = ""
            return cell
        }
        
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("RightDetail", forIndexPath: indexPath)
            cell.textLabel?.text = "Clear Grocery List"
            cell.detailTextLabel?.text = ""
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 {
            let fetchRequest = NSFetchRequest(entityName: "FMLMarket")
            let locations = try! CoreDataStack.sharedStack().managedObjectContext.executeFetchRequest(fetchRequest)
            for location in locations {
                CoreDataStack.sharedStack().managedObjectContext.deleteObject(location as! FMLMarket)
            }
            CoreDataStack.sharedStack().saveContext()
            NSNotificationCenter.defaultCenter().postNotificationName("GetRidOfTheEvidence!", object: nil)
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            cell?.detailTextLabel?.text = "Cleared"
        }
        
        if indexPath.row == 2 {
            let fetchRequest = NSFetchRequest(entityName: "FMLGroceryList")
            let locations = try! CoreDataStack.sharedStack().managedObjectContext.executeFetchRequest(fetchRequest)
            for location in locations {
                CoreDataStack.sharedStack().managedObjectContext.deleteObject(location as! FMLGroceryList)
            }
            CoreDataStack.sharedStack().saveContext()
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            cell?.detailTextLabel?.text = "Cleared"

        }
    }
}
