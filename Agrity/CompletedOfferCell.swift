//
//  AcceptedOfferCell.swift
//  Agrity
//
//  Created by Colin James Dolese on 6/29/16.
//  Copyright © 2016 Agrity. All rights reserved.
//

import UIKit

class CompletedOfferCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var poundsLabel: UILabel!
    // MARK: - Global Vars
    
    var bid: Bid! { didSet { updateUI() } }
    
    func updateUI() {
        priceLabel.text = bid.pricePerPound! + " / lb"
        typeLabel.text = bid.almondVariety! + " " + String(bid.almondSize!)
        if (bid.bidType == 1) {
            poundsLabel.text = String(bid.poundsAccepted!) + " lbs"

        } else {
            poundsLabel.text = "N/A"

        }
    }

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
