//
//  CurrentOfferListController.swift
//  Agrity
//
//  Created by Colin James Dolese on 6/28/16.
//  Copyright © 2016 Agrity. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class CurrentOfferListController: CoreDataTableViewController, UITabBarControllerDelegate {
    
    // MARK: - Global Vars
    
    var managedObjectContext: NSManagedObjectContext? { didSet { setFetchedResultsController() } }
    var currentAccount: GrowerModel? { didSet { updateBids() } }
    
    var bids = [BidModel]()

    
    struct Storyboard {
        static let OfferViewSegue = "toOfferView"
        static let CurrentOfferCellIdentifier = "CurrentOfferCell"
    }
    
    
    private func setFetchedResultsController() {
        if let context = managedObjectContext {
            
            let request = NSFetchRequest(entityName: "Bid")
            
            request.predicate = NSPredicate(format: "bidType == 0")

            
            request.sortDescriptors = [NSSortDescriptor(
                key: "expirationTime",
                ascending: true,
                selector: nil
                )]
            
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        } else {
            fetchedResultsController = nil
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView() 
    //    updateBids()
    //    setFetchedResultsController()
        tabBarController?.delegate = self
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ------------ NEW
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if (bids.count > 0) {
//            return self.bids.count
//        } else {
            return (fetchedResultsController?.fetchedObjects?.count)!
       // }
    }
    
    // ------------ NEW
    
    
    // Display Data - Displays Data from network if available, from NSCoreData otherwise
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CurrentOfferCellIdentifier, forIndexPath: indexPath) as! CurrentOfferCell
        if let bid = fetchedResultsController?.objectAtIndexPath(indexPath) as? Bid {
            if (bids.count > 0) {
                for bidModel in bids {
                    if (bidModel.bidId == bid.bidID) {
                        cell.bid = bidModel
                    }
                }
            }
            let currentDate = NSDate()
            if (bid.expirationTime!.compare(currentDate) == NSComparisonResult.OrderedAscending || bid.expirationTime!.compare(currentDate) == NSComparisonResult.OrderedSame) {
                bid.setValue(3, forKey: "bidType")
                saveDatabase()
            } else {
                bid.managedObjectContext?.performBlockAndWait {
                    cell.bidEntity = bid
                }
            }
        }
        return cell
    }
    
    private func saveDatabase() {
        managedObjectContext?.performBlock {
            do {
                try self.managedObjectContext?.save()
                
            } catch let error {
                print("Error updating database: \(error)")
            }
        }
    }
    

    
    private func updateBids() {
        BidService.sharedInstance.growerID = currentAccount!.id
        BidService.sharedInstance.requestBids { (json: JSON) in
            if let results = json.array {
                for entry in results {
                    let bid = BidModel(json: entry)
                    if (bid.bidResponse?.bidStatus == BidResponse.BidStatus.OPEN) {
                        self.bids.append(bid)
                        self.saveBid(bid)
                    }
                }
                dispatch_async(dispatch_get_main_queue(),{
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    private func saveBid(bid: BidModel) {
        managedObjectContext?.performBlock {
            _ = Bid.saveBidWithBidModel(bid, inManagedObjectContext: self.managedObjectContext!)
            do {
                try self.managedObjectContext?.save()
            } catch let error {
                print("Error updating database: \(error)")
            }
        }

    }
    

    

    // MARK: - Navigation
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        
        
        if identifier == Storyboard.OfferViewSegue {
            if let offerCell = sender as? CurrentOfferCell {
                if (offerCell.bid != nil || offerCell.bidEntity != nil) {
                    return true
                }
            }
        }
        return false
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier {
            if identifier == Storyboard.OfferViewSegue {
                if let offervc = segue.destinationViewController as? CurrentOfferViewController {
                    if let offerCell = sender as? CurrentOfferCell {
                        
                        offerCell.bidEntity.viewed = true
                        UIApplication.sharedApplication().applicationIconBadgeNumber -= 1
                        saveDatabase()
                        offervc.currentAccount = self.currentAccount
                        
                        offervc.bidEntity = offerCell.bidEntity

                        if (offerCell.bid != nil) {
                            offervc.bid = offerCell.bid
                        } else {
                            offervc.networkConnection = false
                        }
                        offervc.managedObjectContext = self.managedObjectContext
                    }
                }
            }
        }
    }
    

}
