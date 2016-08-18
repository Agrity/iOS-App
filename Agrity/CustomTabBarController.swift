//
//  CustomTabBarController.swift
//  Agrity
//
//  Created by Colin James Dolese on 8/9/16.
//  Copyright © 2016 Agrity. All rights reserved.
//

import UIKit

extension UIImage {
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()! as CGContextRef
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        tintColor.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        
        let theme = UIColor(red: 0/255.0, green: 175.0/255.0, blue: 50.0/255.0, alpha: 1.0)

        navigationController!.navigationBar.barTintColor = theme
        
        UITabBar.appearance().barTintColor = theme
        
        for item in self.tabBar.items! as [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithColor(UIColor.whiteColor()).imageWithRenderingMode(.AlwaysOriginal)
            }
        }
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blueColor()], forState:.Selected)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier {
            if (identifier == "toLoginScreen" ){
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(nil, forKey: "currentAccount")
            }
        }
    }

    
    

}
