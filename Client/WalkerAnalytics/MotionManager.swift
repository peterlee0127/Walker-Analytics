//
//  MotionManager.swift
//  WalkerAnalytics
//
//  Created by Peterlee on 10/2/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation

class MotionManager: NSObject {
    var locationManager:CLLocationManager!
    var activityManager:CMMotionActivityManager? //activity
    var pedometer:CMPedometer?  // step
    var altimeter:CMAltimeter?  //altitude
    
    var altitudeQueue:Array<Float>?
    //NetworkManager
    var networkManager:NetworkManager?
    
    // data
    var pedoMeterData:CMPedometerData?  //step
    var activityData:CMMotionActivity?  //activity
    var currentAltitudeData:CMAltitudeData?    //altitude
    {
        didSet{ altitudeDidChange()}
    }
    var moveCount:Int = 0
    var stationaryCount:Int = 0
    
    class var sharedInstance: MotionManager {
    struct Static {
        static var instance: MotionManager?
        static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = MotionManager()
        }
        return Static.instance!
    }
    override init(){
    
        activityManager = CMMotionActivityManager()
        altimeter = CMAltimeter()
        pedometer = CMPedometer()
        altitudeQueue = []
        networkManager = NetworkManager.sharedInstance
    }
    func startTrackingMotion(){
     
        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter!.startRelativeAltitudeUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {  (data:CMAltitudeData!, error) in
                if error == nil {
                    
                  self.currentAltitudeData = data
                    
                }
            })
        }
        if CMPedometer.isStepCountingAvailable() {
            
        
        
        }
        if CMMotionActivityManager.isActivityAvailable() {
            activityManager!.startActivityUpdatesToQueue(NSOperationQueue(), withHandler: { (activity:CMMotionActivity!) -> Void in
                self.activityData = activity
                })       // activity block end
            }  // activity avaiable end
        
    }
    func altitudeDidChange(){
  
        var altitudeValue:NSNumber = NSNumber(float: self.currentAltitudeData!.relativeAltitude!.floatValue)
        NSNotificationCenter.defaultCenter().postNotificationName("kAltitudeChange", object: altitudeValue)
    
        
        altitudeQueue!.append(self.currentAltitudeData!.relativeAltitude.floatValue)
        if(altitudeQueue!.count == 5){
            
            altitudeQueue!.removeAtIndex(0)
//            println(altitudeQueue!)
            
            var first:Float = altitudeQueue!.first! as Float
            var last:Float = altitudeQueue!.last! as Float
            if(abs(last-first)>1.2) {
                
                println("move")
                
                var date:NSDate = NSDate()
                var formatter:NSDateFormatter = NSDateFormatter()
                formatter.dateFormat = "MM/d H:m:ss"
                
                var activityString = "靜止"
                if(self.activityData != nil){
                    if(self.activityData!.walking || self.activityData!.running){
                        activityString = "跑步/走路"
                    }
                    else if(self.activityData!.stationary){
                        activityString = "靜止"
                    }
                    else if(self.activityData!.automotive){
                        activityString = "交通工具"
                    }
                    else if(self.activityData!.cycling){
                        activityString = "腳踏車"
                    }
                }
                    var ascneded = "0"
                    var descended = "0"
                    if(first>last){
                        descended = "1"
                    }
                    else{
                        ascneded = "1"
                    }
                    
                    var location:CLLocation = locationManager!.location!
                    var dict:Dictionary = ["latitude":String(format:"%lf",location.coordinate.latitude),
                        "longitude":String(format:"%lf",location.coordinate.longitude),
                        "altitude":String(format:"%lf",location.altitude),
                        "verticalAccuracy":String(format:"%.3f",location.verticalAccuracy),
                        "horizontalAccuracy":String(format: "%.3f",location.horizontalAccuracy),
                        "time":formatter.stringFromDate(date),
                        "distance":"0",
                        "steps":"0",
                        "floorsAscended":ascneded,
                        "floorsDescended":descended,
                        "activity":activityString]
                
                networkManager!.sendData(dict)
            }
            
        }
        
    }
    
}
