//
//  Grower.swift
//  Agrity
//
//  Created by Colin James Dolese on 6/28/16.
//  Copyright © 2016 Agrity. All rights reserved.
//

import Foundation
import CoreData


class Grower: NSManagedObject {
    
    class func growerWithGrowerModel(newGrower: GrowerModel, inManagedObjectContext context: NSManagedObjectContext) -> Grower? {
        
        let request = NSFetchRequest(entityName: "Grower")
        request.predicate = NSPredicate(format: "email = %@", newGrower.email!)
        
        if let grower = (try? context.executeFetchRequest(request))?.first as? Grower {
            return grower
        } else if let grower = NSEntityDescription.insertNewObjectForEntityForName("Grower", inManagedObjectContext: context) as? Grower {
            grower.firstName = newGrower.firstName
            grower.lastName = newGrower.lastName
            grower.email = newGrower.email
            grower.id = newGrower.id
            return grower
        }
        return nil
        
    }


}
