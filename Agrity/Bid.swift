//
//  Bid.swift
//  Agrity
//
//  Created by Colin James Dolese on 6/29/16.
//  Copyright © 2016 Agrity. All rights reserved.
//

import Foundation
import CoreData


class Bid: NSManagedObject {
    
    // Saves a bid entity after taking in a bidModel object - will serve as ultimate method
    
    class func saveBidWithBidModel(bid: BidModel, inManagedObjectContext context: NSManagedObjectContext) -> Bid? {
        let request = NSFetchRequest(entityName: "Bid")
        request.predicate = NSPredicate(format: "bidID = %d", bid.bidId!)
        if let bidEntity = (try? context.executeFetchRequest(request))?.first as? Bid {
            return bidEntity
        } else if let bidEntity = NSEntityDescription.insertNewObjectForEntityForName("Bid", inManagedObjectContext: context) as? Bid {
            bidEntity.pricePerPound = bid.pricePerPound
            bidEntity.almondSize = bid.almondSize
            bidEntity.almondVariety = bid.almondVariety
            bidEntity.expirationTime = bid.expirationDate
            bidEntity.comment = bid.comment
            bidEntity.bidID = bid.bidId
            bidEntity.almondPounds = bid.almondPounds
            bidEntity.poundsAccepted = bid.bidResponse?.poundsAccepted
            bidEntity.bidType = setType(bid)
            bidEntity.viewed = false
            return bidEntity
        }
        return nil
    }


    private class func setType(bid: BidModel) -> Int {
        if let response = bid.bidResponse?.bidStatus {
            switch response {
            case .OPEN: return 0
            case .ACCEPTED: return 1
            case .REJECTED: return 2
            case .PARTIAL: return 3
            }
        }
        return 0
    }
    
    
}
