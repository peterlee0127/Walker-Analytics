//
//  NetworkManager.swift
//  WalkerAnalytics
//
//  Created by Peterlee on 10/3/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

import UIKit

let saveMotionURL = "http://petertku.no-ip.org/saveMotionData"
let AnalyticsURL = "http://petertku.no-ip.org/getAllList"

@objc protocol NetworkManagerDelegate {
    optional func downloadComplete(data:Array<[String:AnyObject]>!)
}

class NetworkManager: NSObject {
    var delegate:NetworkManagerDelegate?
    class var sharedInstance: NetworkManager {
        struct Static {
            static var instance:NetworkManager?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = NetworkManager()
        }
        return Static.instance!
    }
    func sendData(dict:Dictionary<String,AnyObject>){
        var dictionary:NSDictionary = dict as NSDictionary
        var httpManager = AFHTTPRequestOperationManager()
        httpManager.responseSerializer.acceptableContentTypes = httpManager.responseSerializer.acceptableContentTypes.setByAddingObject("text/html")
        httpManager.requestSerializer = AFHTTPRequestSerializer()
        httpManager.POST(saveMotionURL, parameters: dictionary, success: { (operation, reponseObject) -> Void in
            
            
            }, failure: { (operation, error) -> Void in
                println(error)
        })
    
    
    }
    func getAnalytics() {
    
        var manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json")
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.GET(AnalyticsURL, parameters: nil, success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
            
            var result:Array<[String:AnyObject]> = responseObject as Array<[String:AnyObject]>
            self.delegate!.downloadComplete!(result)
            
        }, failure: { (operation, error) -> Void in
           println(error)
        })
        
    }
}
