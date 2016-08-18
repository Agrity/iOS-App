//
//  GrowerService.swift
//  
//
//  Created by Colin James Dolese on 7/20/16.
//
//

import Foundation
import SwiftyJSON

typealias GrowerServiceResponse = (JSON, NSError?) -> Void

class GrowerService: NSObject {
    static let sharedInstance = GrowerService()
    
    var growerID: Int?
    var growerEmail: String?
    
    
    let baseURL = "http://server.test.agrity.net"
    
    func requestGrower (onCompletion: (JSON) -> Void) {
        let route = getRoute()
        makeGetRequestWithURL(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }

    
    private func getRoute () -> String {
        if (growerEmail != nil) {
           return baseURL + "/grower/email/" + growerEmail!
        } else if (growerID != nil) {
            return baseURL + "/grower/" + String(growerID)
        }
        return ""
    }
    
    private func makeGetRequestWithFile(path: String, onCompletion: GrowerServiceResponse) {
        let jsonData = NSData(contentsOfFile:path)
        let json:JSON = JSON(data: jsonData!)
        onCompletion(json, nil)
    }
    
    private func makeGetRequestWithURL(path: String, onCompletion: GrowerServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if let jsonData = data {
                let json:JSON = JSON(data: jsonData)
                onCompletion(json, error)
            } else {
                onCompletion(nil, error)
            }
        })
        task.resume()
    }
    
}