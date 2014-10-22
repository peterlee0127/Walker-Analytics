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
    var degree:Double?
    
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
    func altitudeDidChange(){   //每次氣壓計Sensor取得新資料，約1s 跑一次此function
        
        var location:CLLocation? = locationManager?.location?
        if(location?.horizontalAccuracy>=25){ // GPS精確度>25m，可能在室內，精確度太低，不取資料
            return  //這次氣壓計變化不取，這次function會在此停止
        }
        
        var altitudeValue:NSNumber = NSNumber(float: self.currentAltitudeData!.relativeAltitude!.floatValue)
        NSNotificationCenter.defaultCenter().postNotificationName("kAltitudeChange", object: altitudeValue)
   
        
        altitudeQueue!.append(self.currentAltitudeData!.relativeAltitude.floatValue)  //把目前的氣壓資料加入Queue
        if(altitudeQueue!.count == 6){  // Queue 滿 8個時
            
            var first:Float = altitudeQueue!.first! as Float  //抓最前面的
            var last:Float = altitudeQueue!.last! as Float  //抓最後面的
            if(abs(last-first)>1.6) {       // 絕對值(最前面-最後面)>
                
                println("move")
            
                var date:NSDate = NSDate() //取得現在時間
                var formatter:NSDateFormatter = NSDateFormatter()
                formatter.dateFormat = "MM/d HH:mm:ss"
               
                var activityString = "靜止"
                if(self.activityData != nil){
                    if(self.activityData!.walking)  {
                        activityString = "走路"
                    }
                    else if(self.activityData!.running) {
                        activityString = "跑步"
                    }
                    else if(self.activityData!.stationary){
                        activityString = "靜止"
                        return  //不取資料
                    }
                    else if(self.activityData!.automotive){
                        activityString = "交通工具"
                        return  //不取資料
                    }
                    else if(self.activityData!.cycling){
                        activityString = "腳踏車"
                        return  //不取資料
                    }
                }
                if(activityString=="靜止"){
                    return
                }
                var floorIsAscended = "-1"
                if(first>=last){
                    floorIsAscended = "0"   //下樓
                }
                else{
                    floorIsAscended = "1"    //上樓
                }
                
                var dict:Dictionary = ["latitude":String(format:"%lf",location!.coordinate.latitude),
                    "longitude":String(format:"%lf",location!.coordinate.longitude),
                    "altitude":String(format:"%lf",location!.altitude),
                    "horizontalAccuracy":String(format:"%.3f",location!.horizontalAccuracy),
                    "time":formatter.stringFromDate(date),
                    "altitudeLog":String(format:"%@",altitudeQueue!),
                    "heading":String(format:"%.f",degree!),
                    "floorIsAscended":floorIsAscended,
                    "activity":activityString]
                
                networkManager!.sendData(dict)      //把資料傳給Server
                
                
           
                
            }
            altitudeQueue!.removeAtIndex(0)
            altitudeQueue!.removeAtIndex(0)
            altitudeQueue!.removeAtIndex(0)
        }
        
    }
    
}
