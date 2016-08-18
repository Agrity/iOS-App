//
//  BidModel.swift
//  Agrity
//
//  Created by Colin James Dolese on 7/18/16.
//  Copyright © 2016 Agrity. All rights reserved.
//

import Foundation
import SwiftyJSON

extension NSDate
{
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
}

class BidModel {
    
    var bidId: Int?
    var almondVariety: String?
    var almondSize: String?
    var almondPounds: Int?
    var pricePerPound: String?
    var comment: String?
    var bidResponse: BidResponse?
    var expirationDate: NSDate?
    
    required init(json: JSON) {
        bidId = json["id"].intValue
        almondVariety = json["almondVariety"].stringValue
        almondSize = json["almondSize"].stringValue
        almondPounds = json["almondPounds"].intValue
        pricePerPound = json["pricePerPound"].stringValue
        comment = json["comment"].stringValue
        parseBidResponse(json)
        parseExpirationTime(json)
    }

    private func parseBidResponse(json: JSON) {
        let bidStatus = json["bidStatus"].stringValue
        bidResponse = BidResponse()
//        switch bidStatus {
//            case "PARTIAL": bidResponse?.bidStatus = BidResponse.BidStatus.PARTIAL
//            case "ACCEPTED": bidResponse?.bidStatus = BidResponse.BidStatus.ACCEPTED
//            case "REJECTED": bidResponse?.bidStatus = BidResponse.BidStatus.REJECTED
//            default: bidResponse?.bidStatus = BidResponse.BidStatus.OPEN
//        }
        bidResponse?.poundsAccepted = json["poundsAccepted"].doubleValue
    }
    
    private func parseExpirationTime(json: JSON) {
        let comp = NSDateComponents()
        comp.hour = 21
        comp.minute = 59
        comp.second = 20
        comp.day = 18
        comp.month = 8
        comp.year = 2016
//        comp.hour = json["expirationTime"]["hour"].intValue
//        comp.minute = json["expirationTime"]["minute"].intValue
//        comp.second = json["expirationTime"]["second"].intValue
//        comp.day = json["expirationTime"]["dayValue"].intValue
//        comp.month = json["expirationTime"]["monthValue"].intValue
//        comp.year = json["expirationTime"]["year"].intValue
        let date = NSCalendar(identifier: NSCalendarIdentifierGregorian)?.dateFromComponents(comp)
        expirationDate = date
    }
    

    
    
}