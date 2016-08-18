//
//  CurrentOfferCell.swift
//  Agrity
//
//  Created by Colin James Dolese on 6/29/16.
//  Copyright © 2016 Agrity. All rights reserved.
//

import UIKit
import CoreData

class CurrentOfferCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var poundsLabel: UILabel!
    
    // MARK: - Global Vars
    
    var bid: BidModel! //{ didSet { updateUIWithBidModel() } }
    
    var bidEntity: Bid! { didSet { updateUIWithBidEntity() } }

    
    private func updateUIWithBidEntity() {
        offerLabel.text = bidEntity.pricePerPound! + " / lb"
        typeLabel.text = bidEntity.almondVariety! + " " + String(bidEntity.almondSize!)
        poundsLabel.text = String(bidEntity.almondPounds!) + " lbs"
        let calendar = NSCalendar.currentCalendar()
        let datecomponenets = calendar.components([.Second, .Minute, .Hour, .Day, .Month], fromDate: NSDate(), toDate: bidEntity.expirationTime!, options: NSCalendarOptions.MatchFirst)
        timeRemainingLabel.text = self.stringFromDateComponents(datecomponenets) as String
        if (bidEntity.viewed == false) {
            boldLabels()
        } else {
            noBold()
        }
    }
    
    private func boldLabels() {
        offerLabel.font = UIFont.boldSystemFontOfSize(17.0)
        typeLabel.font = UIFont.boldSystemFontOfSize(17.0)
        poundsLabel.font = UIFont.boldSystemFontOfSize(17.0)
        timeRemainingLabel.font = UIFont.boldSystemFontOfSize(17.0)
    }
    
    private func noBold() {
        offerLabel.font = UIFont.systemFontOfSize(17.0)
        typeLabel.font = UIFont.systemFontOfSize(17.0)
        poundsLabel.font = UIFont.systemFontOfSize(17.0)
        timeRemainingLabel.font = UIFont.systemFontOfSize(17.0)
    }
    
    
    private func stringFromDateComponents(components: NSDateComponents) -> NSString {
        if (components.month >= 1) {
            return NSString(format: "%d Month(s)", components.month)
        } else if (components.day >= 1) {
            return NSString(format: "%d Day(s)", components.day)
        } else if (components.hour >= 1) {
            return NSString(format: "%d Hour(s)", components.hour)
        } else {
            return NSString(format: "%d Minute(s)", components.minute)

        }
    }

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
