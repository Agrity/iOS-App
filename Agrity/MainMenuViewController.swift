//
//  MainMenuViewController.swift
//  Agrity
//
//  Created by Colin James Dolese on 6/23/16.
//  Copyright © 2016 Agrity. All rights reserved.
//

import UIKit
import CoreData

class MainMenuViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var nameEntry: UITextField!
    @IBOutlet weak var passwordEntry: UITextField!
    
    // MARK: - Global Vars
    
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext

    
    // MARK: - Local Vars
    
    private var canSegue = false
    private var fetchedAccount: GrowerModel?

    
    
    struct Storyboard {
        static let setupAccount = "toAccountCreation"
        static let login = "toHomeScreen"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        if (defaults.objectForKey("currentAccount") != nil) {
            getAccount()
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier(Storyboard.login, sender: self)
            }
        }
        logo.image = UIImage(named: "formattedLogo")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func goPressed(sender: AnyObject) {
        if (fieldsFilled()) {
            getAccount()
        }

    }
    
    private func getAccount() {
        if let context = managedObjectContext {
            let request = NSFetchRequest(entityName: "Grower")
            if (nameEntry.text == "") {
                let defaults = NSUserDefaults.standardUserDefaults()
                if let name = defaults.objectForKey("currentAccount") as! String? {
                    request.predicate = NSPredicate(format: "any lastName == %@", name)
                }
            } else {
                request.predicate = NSPredicate(format: "any lastName == %@", nameEntry.text!)
            }
            do {
                let fetchedEntities = try context.executeFetchRequest(request) as! [Grower]
                if let grower = fetchedEntities.first {
                    if (grower.password == passwordEntry.text || nameEntry.text == "") {
                        canSegue = true
                   //     fetchedAccount = grower
                    }
                }
            } catch {
                // Do something in response to error condition
            }
        }

    }
    
    private func fieldsFilled() -> Bool {
        if nameEntry.text == nil {
            return false
        }
        if passwordEntry.text == nil {
            return false
        }
        return true
    }
    


    // MARK: - Navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if (identifier == Storyboard.setupAccount) {
            return true
        }
        if (identifier == Storyboard.login) {
            if (canSegue == true) {
                return true
            }
        }
        return false
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destVC = segue.destinationViewController
        if let navcon = destVC as? UINavigationController {
            destVC = navcon.visibleViewController ?? destVC
        }
        if let identifier = segue.identifier {
            
            if identifier == Storyboard.setupAccount {
                let destVC = segue.destinationViewController as! AccountCreationViewController
                destVC.managedObjectContext = self.managedObjectContext
            } else if identifier == Storyboard.login {
                let nav = segue.destinationViewController as! UINavigationController
                let destVC = nav.topViewController as! HomeViewController
                destVC.currentAccount = fetchedAccount
                destVC.managedObjectContext = self.managedObjectContext
            }
            
        }

    }
    
    
    

}
