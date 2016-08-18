//
//  AccountCreationViewController.swift
//  Agrity
//
//  Created by Colin James Dolese on 6/27/16.
//  Copyright © 2016 Agrity. All rights reserved.
//

//
// Allows user to create an Account entity
// and save it in Core Data with the users
// relevant information.
//


// TO ADD: Sign up via Google/Facebook?

import UIKit
import CoreData

// Temporary holder of account information 

struct Account {
    var firstName = ""
    var lastName = ""
    var handler = ""
    var password = ""
}

class AccountCreationViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var firstNameEntry: UITextField!
    @IBOutlet weak var lastNameEntry: UITextField!
    @IBOutlet weak var handlerEntry: UITextField!
    @IBOutlet weak var passwordEntry: UITextField!
    
     // MARK: - Global Vars

    var managedObjectContext: NSManagedObjectContext?
    
    // MARK: - Local Vars
    
    private var canSegue = false
    private var newAccount: Account?
    
    
    struct Storyboard {
        static let homeScreen = "toHomeScreen"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    private func createAccount() {
//        let account = fillAccount()
//        self.newAccount = account
//        if (accountFilled(account)) {
//            self.canSegue = true
//            managedObjectContext?.performBlock {
//                _ = Grower.growerWithAccountData(account, name: account.lastName, inManagedObjectContext: self.managedObjectContext!)
//                do {
//                    try self.managedObjectContext?.save()
//                    
//                } catch let error {
//                    print("Error updating database: \(error)")
//                }
//            }
//        }
        
    }
    
    private func fillAccount() -> Account {
        var newAccount = Account()
        if let firstName = firstNameEntry.text {
            newAccount.firstName = firstName
        }
        if let lastName = lastNameEntry.text {
            newAccount.lastName = lastName
        }
        if let handler = handlerEntry.text {
            newAccount.handler = handler
        }
        if let password = passwordEntry.text {
            newAccount.password = password
        }
        return newAccount
    }
    
    private func accountFilled(account: Account) -> Bool {
        if (account.firstName == "" || account.lastName == "" || account.handler == "" || account.password == "") {
            return false
        }
        return true
    }

    // MARK: - Navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        createAccount()
        if identifier == Storyboard.homeScreen {
            if (canSegue == true) {
                return true
            }
        }
        return false
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        var destVC = segue.destinationViewController
//        if let navcon = destVC as? UINavigationController {
//            destVC = navcon.visibleViewController ?? destVC
//        }
//        if (canSegue) {
//            if let identifier = segue.identifier {
//                if identifier == Storyboard.homeScreen {
//                    let nav = segue.destinationViewController as! UINavigationController
//                    let destVC = nav.topViewController as! HomeViewController
//                    destVC.growerName = newAccount?.lastName
//                    destVC.managedObjectContext = self.managedObjectContext
//                }
//            }
//        }
    }

}
