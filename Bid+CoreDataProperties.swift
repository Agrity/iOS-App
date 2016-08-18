//
//  Bid+CoreDataProperties.swift
//  
//
//  Created by Colin James Dolese on 8/9/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Bid {

    @NSManaged var almondPounds: NSNumber?
    @NSManaged var almondSize: String?
    @NSManaged var almondVariety: String?
    @NSManaged var bidID: NSNumber?
    @NSManaged var bidType: NSNumber?
    @NSManaged var comment: String?
    @NSManaged var expirationTime: NSDate?
    @NSManaged var poundsAccepted: NSNumber?
    @NSManaged var pricePerPound: NSNumber?
    @NSManaged var responseStatus: String?
    @NSManaged var viewed: NSNumber?
    @NSManaged var grower: NSSet?
    @NSManaged var handler: Handler?

}
