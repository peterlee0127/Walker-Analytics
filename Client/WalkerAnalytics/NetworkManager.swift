//
//  NetworkManager.swift
//  WalkerAnalytics
//
//  Created by Peterlee on 10/3/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
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
    func sendData(dict:Dictionary<String,String>){
        var dictionary:NSDictionary = dict as NSDictionary
        var httpManager = AFHTTPRequestOperationManager()
        httpManager.responseSerializer.acceptableContentTypes = httpManager.responseSerializer.acceptableContentTypes.setByAddingObject("text/html")
        httpManager.POST("http://petertku.no-ip.org:8082/saveMotionData", parameters: dictionary, success: { (operation, reponseObject) -> Void in
            
            
            }, failure: { (operation, error) -> Void in
                
        })
    
    
    }
}
