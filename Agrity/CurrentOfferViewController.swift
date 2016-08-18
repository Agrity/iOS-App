//
//  CurrentOfferViewController.swift
//  Agrity
//
//  Created by Colin James Dolese on 7/4/16.
//  Copyright © 2016 Agrity. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class CurrentOfferViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var varietyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var poundsLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var poundsStepper: UIStepper!
    
    // MARK: - Global Vars
    
    var managedObjectContext: NSManagedObjectContext?
    var bid: BidModel?
    var bidEntity: Bid?
    var currentAccount: GrowerModel?
    var networkConnection = true
    var bidExpired = false
    var expirationDate: NSDate?


    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewWithBidEntity()
        poundsStepper.autorepeat = true
        navigationItem.title = "Bid Details"
    }
    
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        
        // format buttons
        
        acceptButton.layer.borderWidth = 1.0
        acceptButton.layer.masksToBounds = true
        acceptButton.layer.cornerRadius = 6
        acceptButton.clipsToBounds = true
        rejectButton.layer.borderWidth = 1.0
        rejectButton.layer.masksToBounds = true
        rejectButton.layer.cornerRadius = 6
        rejectButton.clipsToBounds = true
        
        // format pounds label
        
        poundsLabel.layer.borderColor = UIColor.blackColor().CGColor
        poundsLabel.layer.borderWidth = 0.5
        
        // format comment
        let commentBackground = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)
        commentLabel.backgroundColor = commentBackground
    }
    
    private func setupViewWithBidEntity() {
        varietyLabel.text = (bidEntity?.almondVariety)! + " " + String(bidEntity!.almondSize!)
        poundsLabel.text = String(bidEntity!.almondPounds!)
        priceLabel.text = bidEntity!.pricePerPound! + " / lb"
        commentLabel.text = " " + (bidEntity?.comment)! + " "
        
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([.Second, .Minute, .Hour, .Day, .Month], fromDate: NSDate(), toDate: bidEntity!.expirationTime!, options: NSCalendarOptions.MatchFirst)
        if (dateComponents.second <= 0) {
            let zeroComponents = calendar.components([.Second, .Minute, .Hour, .Day, .Month], fromDate: NSDate(), toDate: NSDate(), options: NSCalendarOptions.MatchFirst)
            timeRemainingLabel.text = self.stringFromDateComponents(zeroComponents) as String
            bidExpired = true
            timeRemainingLabel.textColor = UIColor.redColor()
        } else {
            timeRemainingLabel.text = self.stringFromDateComponents(dateComponents) as String
            expirationDate = bidEntity?.expirationTime
            if (dateComponents.hour < 1) {
                _ = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
            }
        }
        poundsStepper.maximumValue = Double((bidEntity?.almondPounds)!)
        poundsStepper.value = Double((bidEntity?.almondPounds)!)
    }
    
    // Updates remaining time countdown
    
    @objc private func updateCounter(timer: NSTimer) {
        
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([.Second, .Minute, .Hour, .Day, .Month], fromDate: NSDate(), toDate: expirationDate!, options: NSCalendarOptions.MatchFirst)
        if (dateComponents.hour == 0 && dateComponents.minute == 0 && dateComponents.second == 0) {
            timer.invalidate()
            informUserBidExpired()
            timeRemainingLabel.textColor = UIColor.redColor()
            bidExpired = true
            
        }
        timeRemainingLabel.text = self.stringFromDateComponents(dateComponents) as String
        
    }
    
    
    @IBAction func poundsChanged(sender: UIStepper) {
        poundsLabel.text = Int(sender.value).description
    }
    
    
//    private func updateBid() {
//        var updates = [String:AnyObject]()
//        updates["response_status"] = bid!.bidResponse
//        BidService.sharedInstance.updates = updates
//        BidService.sharedInstance.updateBid { (json:JSON) in
//            dispatch_async(dispatch_get_main_queue(),{
//                self.loadView()
//            })
//        }
//    }
    
    // Parse date into hours, minutes, seconds
    
    private func stringFromDateComponents(components: NSDateComponents) -> NSString {
        if (components.month >= 1) {
            return NSString(format: "%d Month(s)", components.month)
        }
        else if (components.day >= 1) {
            return NSString(format: "%d Day(s)", components.day)
        } else if (components.hour >= 1) {
            return NSString(format: "%d Hour(s)", components.hour)
        } else {
            return NSString(format: "%0.2d:%0.2d", components.minute, components.second)

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - Messages to user
    
    
    private func informUserBidExpired() {
        let alert = UIAlertController(title: "Bid Expired!", message: "The time limit set on this bid has passed.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func informUserNoNetworkConnection() {
        let alert = UIAlertController(title: "No Network Connection", message: "You must be connected to the internet to interact with an active bid.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

    // MARK: - Navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if (networkConnection && !bidExpired) {
            return true
        } else if (bidExpired) {
            informUserBidExpired()
        } else {
            informUserNoNetworkConnection()
        }
        return false
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (sender!.titleLabel!!.text == "ACCEPT") {
            bid?.bidResponse?.bidStatus = BidResponse.BidStatus.ACCEPTED
            bidEntity?.bidType = 1
            bidEntity?.poundsAccepted = Double(poundsLabel.text!)
            bid?.bidResponse?.poundsAccepted = Double(poundsLabel.text!)
            
        }
        if (sender!.titleLabel!!.text == "REJECT") {
            bid?.bidResponse?.bidStatus = BidResponse.BidStatus.REJECTED
            bidEntity?.bidType = 2
        }
        // updateBid()
        let nav = segue.destinationViewController as! UINavigationController
        let barViewController = nav.topViewController as! UITabBarController
        let destinationvc1 = barViewController.viewControllers![0] as! CurrentOfferListController
        destinationvc1.currentAccount = self.currentAccount
        destinationvc1.managedObjectContext = self.managedObjectContext
        let destinationvc2 = barViewController.viewControllers![1] as! CompletedOffersListController
        destinationvc2.currentAccount = self.currentAccount
        destinationvc2.managedObjectContext = self.managedObjectContext
    }


}
