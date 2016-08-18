//
//  HomeViewController.swift
//  Agrity
//
//  Created by Colin James Dolese on 6/28/16.
//  Copyright © 2016 Agrity. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    // MARK: - Global Vars
    
    var items = [BidModel]()
    
    
    var managedObjectContext: NSManagedObjectContext?
    var currentAccount: GrowerModel?
    var growerEmail: String?
    
    struct Storyboard {
        static let offerLists = "toOfferLists"
        static let logout = "toMainMenu"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destVC = segue.destinationViewController
        if let navcon = destVC as? UINavigationController {
            destVC = navcon.visibleViewController ?? destVC
        }
        if let identifier = segue.identifier {
            if identifier == Storyboard.offerLists {
                let barViewController = segue.destinationViewController as! UITabBarController
                let destinationvc1 = barViewController.viewControllers![0] as! CurrentOfferListController
                destinationvc1.currentAccount = self.currentAccount
                destinationvc1.managedObjectContext = self.managedObjectContext
                let destinationvc2 = barViewController.viewControllers![1] as! CompletedOffersListController
                destinationvc2.currentAccount = self.currentAccount
                destinationvc2.managedObjectContext = self.managedObjectContext
            }
            if identifier == Storyboard.logout {
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(nil, forKey: "currentAccount")
            }
        }
    }

}
