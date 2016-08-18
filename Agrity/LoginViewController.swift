//
//  LoginViewController.swift
//  Agrity
//
//  Created by Colin James Dolese on 7/25/16.
//  Copyright © 2016 Agrity. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON


class LoginViewController: UIViewController {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var emailEntry: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Global Vars
    
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    
    // MARK: - Local Vars
    
    private var canSegue = false
    private var fetchedAccount: GrowerModel?
    private var accountEmail: String?
    
    
    
    struct Storyboard {
        static let login = "toOfferLists"
    }
    
    
    
    @IBAction func loginPressed(sender: AnyObject) {
        if (emailEntry.text != nil) {
            getAccountWithEmail(emailEntry.text!)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        if let email = defaults.objectForKey("currentAccount") {
            getAccountWithEmail(email as! String)
        }
        logo.image = UIImage(named: "Logo2Formatted")
        self.navigationController?.navigationBarHidden = true

    }
    
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        loginButton.layer.borderWidth = 1.0
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 6
        loginButton.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    private func getAccountWithEmail(requestedEmail: String) {
        if isValidEmail(requestedEmail){
            
            GrowerService.sharedInstance.growerEmail = requestedEmail
            GrowerService.sharedInstance.requestGrower { (json: JSON) in
                let grower = GrowerModel(json: json)
                if (grower.email == requestedEmail) {
                    self.canSegue = true
                    self.fetchedAccount = grower
                    let defaults = NSUserDefaults.standardUserDefaults()
                    if (defaults.objectForKey("currentAccount") == nil) {
                        defaults.setObject(self.fetchedAccount?.email, forKey: "currentAccount")
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier(Storyboard.login, sender: self)
                    }
                    
                    
                } else {
                    self.informUserEmailNotFound()
                }
            }
        }
        else {
            informUserEntryInvalid()
        }
    }
    
    // Validates user's entry to see if it is a valid email address before making
    // request to network
    
    private func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(testStr)
        return result
    }
    
    // MARK - Standard iOS message informing user the email entered does not belong to a grower
    
    private func informUserEmailNotFound() {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            let alert = UIAlertController(title: "Email Not Found", message: "The email you entered has not been registered by a handler.  Contact your handler to get signed up!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    private func informUserEntryInvalid() {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            let alert = UIAlertController(title: "Invalid Entry", message: "Please enter a properly formatted email address.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    // MARK - save grower to core data, currently not in use
    
    private func saveGrower() {
            managedObjectContext?.performBlock {
                _ = Grower.growerWithGrowerModel(self.fetchedAccount!, inManagedObjectContext: self.managedObjectContext!)
                do {
                    try self.managedObjectContext?.save()
                    
                } catch let error {
                    print("Error updating database: \(error)")
                }
        }
    }
    
    ///////////////////////


    
    
    // MARK: - Navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
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
            if identifier == Storyboard.login {
                
                let nav = segue.destinationViewController as! UINavigationController
                let barViewController = nav.topViewController as! UITabBarController
                let destinationvc1 = barViewController.viewControllers![0] as! CurrentOfferListController
                destinationvc1.currentAccount = self.fetchedAccount
                destinationvc1.managedObjectContext = self.managedObjectContext
                let destinationvc2 = barViewController.viewControllers![1] as! CompletedOffersListController
                destinationvc2.currentAccount = self.fetchedAccount
                destinationvc2.managedObjectContext = self.managedObjectContext
            }

        }
    }
    
}
