//
//  NetworkManager.swift
//  WalkerAnalytics
//
//  Created by Peterlee on 10/3/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

import UIKit
import Alamofire

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
        var httpManager = Alamofire.request(.POST, saveMotionURL, parameters: dict, encoding: ParameterEncoding.JSON, headers: nil)
    
    }
    func getAnalytics() {
        var httpManager = Alamofire.request(.GET, AnalyticsURL, parameters: nil, encoding: ParameterEncoding.JSON, headers: nil).responseString {
            response in
            if response.result.isSuccess {
                if let res = response.result.value as? [[String:AnyObject]] {
                    self.delegate!.downloadComplete!(res)
                }
            }
        }
        
        
    }
}