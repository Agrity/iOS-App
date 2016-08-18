//
//  MakeBidController.swift
//  Agrity
//
//  Created by Colin James Dolese on 6/29/16.
//  Copyright © 2016 Agrity. All rights reserved.
//

// FOR TESTING ONLY
// Allows user to create and store a
// bid of the same format which the app
// will eventually be recieving via the network.

import UIKit
import CoreData

// Temporary Holder of BidInfo

struct BidInfo {
    var handler = ""
    var variety = ""
    var size = ""
    var price = 0.0
    var startDate: NSDate?
    var endDate: NSDate?
    var expirationTime: NSDate?
    var comment = ""
    var bidType = 0
}


class MakeBidController: UIViewController {
  
    // MARK: - Outlets

    @IBOutlet weak var handlerEntry: UITextField!
    @IBOutlet weak var varietyEntry: UITextField!
    @IBOutlet weak var sizeEntry: UITextField!
    @IBOutlet weak var priceEntry: UITextField!
    @IBOutlet weak var commentEntry: UITextField!
    @IBOutlet weak var expirationTimeEntry: UITextField!
    
    // MARK: - Global Vars
    
    var managedObjectContext: NSManagedObjectContext?
    var canSegue = false
    var currentAccount: GrowerModel?
    
    
    
    struct Storyboard {
        static let homeScreen = "toHomeScreen"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func makeBid() {
        let newBid = fillBid()
        if (bidFilled(newBid)) {
            self.canSegue = true
            managedObjectContext?.performBlock {
                _ = Bid.bidWithBidData(newBid, name: newBid.handler, startDate: newBid.startDate!, inManagedObjectContext: self.managedObjectContext!)
                do {
                    try self.managedObjectContext?.save()
                } catch let error {
                    print("Error updating database: \(error)")
                }
            }
        }
    }
    
    private func fillBid() -> BidInfo {
        var newBid = BidInfo()
        if let handler = handlerEntry.text {
            newBid.handler = handler
        }
        if let variety = varietyEntry.text {
            newBid.variety = variety
        }
        if let size = sizeEntry.text {
            newBid.size = Double(size)!
        }
        if let price = priceEntry.text {
            newBid.price = Double(price)!
        }
        if let comment = commentEntry.text {
            newBid.comment = comment
        }
        if let expirationTime = expirationTimeEntry.text {
            let currentDate = NSDate()
            let expirationDate = currentDate.dateByAddingTimeInterval(Double(expirationTime)!*60)
            newBid.expirationTime = expirationDate
        }
        newBid.endDate = NSDate()
        newBid.startDate = NSDate()
        return newBid
    }
    
    private func bidFilled(bid: BidInfo) -> Bool {
        if (bid.handler == "" || bid.variety == "" || bid.size == 0.0 || bid.price == 0.0 || bid.comment == "" || bid.expirationTime == nil) {
            return false
        }
        return true
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        makeBid()
        if identifier == Storyboard.homeScreen {
            if (canSegue == true) {
                return true
            }
        }
        return false
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destVC = segue.destinationViewController
        if let navcon = destVC as? UINavigationController {
            destVC = navcon.visibleViewController ?? destVC
        }
        if (canSegue) {
            if let identifier = segue.identifier {
                if identifier == Storyboard.homeScreen {
                    let nav = segue.destinationViewController as! UINavigationController
                    let destVC = nav.topViewController as! HomeViewController
                    destVC.currentAccount = self.currentAccount
                    destVC.managedObjectContext = self.managedObjectContext
                }
            }
        }
    }


}
