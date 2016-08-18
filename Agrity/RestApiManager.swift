//
//  RestApiManager.swift
//  Agrity
//
//  Created by Colin James Dolese on 7/16/16.
//  Copyright © 2016 Agrity. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias ServiceResponse = (JSON, NSError?) -> Void

class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()
    
    var request: Route? { didSet { /* add */ } }
    
    enum Route {
        case GETHANDLERS
        case GETGROWERS
        case GETBIDS
        
    }
    
    
    let baseURL = "http://app.agrity.net"
    
    func requestData (onCompletion: (JSON) -> Void) {
//        let route = baseURL + getRoute(request!)
//        makeGetRequest(route, onCompletion: { json, err in
//            onCompletion(json as JSON)
//        })
    }
    
    private func getHandlers() {
        
    }
    
    private func getBids() {
        
    }
    
    private func getRoute (route: Route) -> String {
        switch route {
            case .GETHANDLERS: return "TO DO"
            case .GETGROWERS: return "TO DO"
            case .GETBIDS: return "TO DO"
        }
    }
    
    private func makeGetRequest(path: String, onCompletion: ServiceResponse) {
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