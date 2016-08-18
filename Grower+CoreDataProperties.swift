//
//  Grower+CoreDataProperties.swift
//  
//
//  Created by Colin James Dolese on 8/16/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Grower {

    @NSManaged var email: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var id: NSNumber?
    @NSManaged var bids: NSSet?

}
