//
//  GrowerModel.swift
//  Agrity
//
//  Created by Colin James Dolese on 7/18/16.
//  Copyright © 2016 Agrity. All rights reserved.
//

import Foundation
import SwiftyJSON

class GrowerModel {
    
    var email: String?
    var firstName: String?
    var lastName: String?
    var id: Int?
    
    required init(json: JSON) {
        email = json["emailAddressString"].stringValue
        firstName = json["firstName"].stringValue
        lastName = json["lastName"].stringValue
        id = json["id"].intValue
    }
}