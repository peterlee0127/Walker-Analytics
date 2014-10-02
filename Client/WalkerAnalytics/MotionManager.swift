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
    var locationManager:CLLocationManager?
    var activityManager:CMMotionActivityManager? //activity
    var pedometer:CMPedometer?  // step
    var altimeter:CMAltimeter?  //altitude
    
    // data
    var pedoMeterData:CMPedometerData?  //step
    var activityData:CMMotionActivity?  //activity
    var currentAltitudeData:CMAltitudeData?    //altitude
    {
        didSet{ altitudeDidChange()}
    }
    var previousAltitudeData:CMAltitudeData?
    var count:Int = 0
    
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
       
        //
        if(self.previousAltitudeData==nil){
            self.previousAltitudeData = self.currentAltitudeData
        }
//        println(String(format: "previous:%.2fm \t current:%.2fm",self.previousAltitudeData!.relativeAltitude!.floatValue, self.currentAltitudeData!.relativeAltitude!.floatValue))
        if(abs(self.previousAltitudeData!.relativeAltitude!.floatValue-self.currentAltitudeData!.relativeAltitude!.floatValue)>0.3){
            if(count==2){
                println("moved")
                count = 0
            }
            count++
        }
        
        
       self.previousAltitudeData = self.currentAltitudeData!
    }
    
}
