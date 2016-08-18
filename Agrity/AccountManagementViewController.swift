//
//  AccountManagementViewController.swift
//  Agrity
//
//  Created by Colin James Dolese on 7/6/16.
//  Copyright © 2016 Agrity. All rights reserved.
//


//
// Allows the user to manipulate previously
// set values in regards to their account data.
//

import UIKit
import CoreData

class AccountManagementViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var newHandlerEntry: UITextField!
    @IBOutlet weak var newPasswordEntry: UITextField!
    
    // MARK: - Global Vars
    
    var managedObjectContext: NSManagedObjectContext?
    var currentAccount: GrowerModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func updateAccount(sender: AnyObject) {
//        let grower = Grower.getGrower((currentAccount?.lastName)!, inManagedObjectContext: managedObjectContext!)
//        if (newHandlerEntry.text != "") {
//            if let newHandler = Handler.getHandler(newHandlerEntry.text!, inManagedObjectContext: managedObjectContext!) {
//                grower?.handler = newHandler
//            }
//            
//        }
//        if (newPasswordEntry.text! != "") {
//            grower!.setValue(newPasswordEntry.text!, forKey: "password")
//        }
//        saveDatabase()
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
    

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }

}
