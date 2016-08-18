//
//  CompletedOffersViewController.swift
//  Agrity
//
//  Created by Colin James Dolese on 7/2/16.
//  Copyright © 2016 Agrity. All rights reserved.
//

import UIKit
import CoreData

class CompletedOffersListController: CoreDataTableViewController, UINavigationControllerDelegate {
    
    // MARK: - Global Vars
  
    var managedObjectContext: NSManagedObjectContext? { didSet { updateUI() } }
    var currentAccount: GrowerModel?
    
    let section = ["Accepted", "Rejected", "Expired"]
    
    struct Storyboard {
        static let CompletedOfferCellIdentifier = "CompletedCell"
    }
    
    
    private func updateUI() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        if let context = managedObjectContext {
            
            let request = NSFetchRequest(entityName: "Bid")
            
            request.predicate = NSPredicate(format: "bidType != 0")

            
            request.sortDescriptors = [NSSortDescriptor(
                key: "bidType",
                ascending: true,
                selector: nil
                )]
            
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "bidType", cacheName: nil)
        } else {
            fetchedResultsController = nil
        }
    }
    
        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.estimatedRowHeight = tableView.rowHeight
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.tableFooterView = UIView() 
            updateUI()
            navigationController?.delegate = self
            // Uncomment the following line to preserve selection between presentations
            // self.clearsSelectionOnViewWillAppear = false
    
            // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
            // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: Allows deleting of bids
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case.Delete:
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context: NSManagedObjectContext = appDel.managedObjectContext
            context.deleteObject((fetchedResultsController?.objectAtIndexPath(indexPath))! as! NSManagedObject)
            do {
                try context.save()
            } catch _ {
        }
        updateUI()
        default:
            return
        }
    }

//
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return self.section[section]
//    }
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // MARK: - Table view data source and formatting
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CompletedOfferCellIdentifier, forIndexPath: indexPath) as! CompletedOfferCell
        if let bid = fetchedResultsController?.objectAtIndexPath(indexPath) as? Bid {
            bid.managedObjectContext?.performBlockAndWait {
                cell.bid = bid
            }
        }
        return cell
    }
    
    
     // MARK: - Navigation
//    
//    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
//        if let controller = viewController as? HomeViewController {
//            controller.managedObjectContext = self.managedObjectContext
//        }
//    }
    
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
    
}

