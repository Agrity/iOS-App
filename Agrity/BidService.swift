//
//  BidService.swift
//  Agrity
//
//  Created by Colin James Dolese on 7/20/16.
//  Copyright © 2016 Agrity. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias BidServiceResponse = (JSON, NSError?) -> Void

class BidService: NSObject {
    static let sharedInstance = BidService()
        
    enum Route {
        case GETBIDS
        
    }
    
    var updates = [String:AnyObject]()
    
    var growerID: Int?
    
    let baseURL = "http://server.test.agrity.net"
    
    func requestBids (onCompletion: (JSON) -> Void) {
        let route = baseURL + "/grower/" + String(growerID!) + "/handlerBids"
     //   let route = NSBundle.mainBundle().pathForResource("TestBid", ofType: "json")
     //   makeGetRequestWithFile(route!, onCompletion: {json, err in onCompletion(json as JSON) })
            makeGetRequestWithURL(route, onCompletion: { json, err in
                onCompletion(json as JSON)
            })
    }
    
    func updateBid(onCompletion: (JSON) -> Void) {
        let route = baseURL + "/grower/" + String(growerID!) + "/handlerBids"
        
    }
    
    
        
    private func makeGetRequestWithFile(path: String, onCompletion: BidServiceResponse) {
        let jsonData = NSData(contentsOfFile:path)
        let json:JSON = JSON(data: jsonData!)
        onCompletion(json, nil)
    }
    
    private func makeGetRequestWithURL(path: String, onCompletion: BidServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let session = NSURLSession.sharedSession()
        print(path)
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
    
    // MARK: POST requests
    
    private func makePostRequestWithURL(path: String, body: [String: AnyObject], onCompletion: BidServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        // Set the method to POST
        request.HTTPMethod = "POST"
        
        do {
            // Set the POST body for the request
            let jsonBody = try NSJSONSerialization.dataWithJSONObject(body, options: .PrettyPrinted)
            request.HTTPBody = jsonBody
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                if let jsonData = data {
                    let json:JSON = JSON(data: jsonData)
                    onCompletion(json, nil)
                } else {
                    onCompletion(nil, error)
                }
            })
            task.resume()
        } catch {
            onCompletion(nil, nil)
        }
    }
    
}