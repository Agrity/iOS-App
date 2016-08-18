//
//  BidResponse.swift
//  Agrity
//
//  Created by Colin James Dolese on 7/19/16.
//  Copyright © 2016 Agrity. All rights reserved.
//

import Foundation

class BidResponse {

    enum BidStatus {
        case ACCEPTED
        case REJECTED
        case OPEN
        case PARTIAL
    }
    
    var bidStatus: BidStatus?
    var poundsAccepted: Double?
    
    required init () {
        bidStatus = BidStatus.OPEN
        poundsAccepted = 0
 
    }
    
}
