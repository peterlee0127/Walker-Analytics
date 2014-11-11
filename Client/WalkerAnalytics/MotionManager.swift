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
    
    var relAltitudeQueue:Array<Float>?
    var locationQueue:Array<CLLocationCoordinate2D>?
    var mapAltitudeQueue:Array<Float>?
    var stairsChecking:Bool = false
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
        relAltitudeQueue = []
        locationQueue = []
        mapAltitudeQueue = []
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
    func getActivityString() ->String {
        if(self.activityData != nil){
            if(self.activityData!.walking)  {
                return "走路"
            }
            else if(self.activityData!.running) {
                return "跑步"
            }
            else if(self.activityData!.stationary){
                return "" //不取資料
            }
            else if(self.activityData!.automotive){
                return  ""//不取資料
            }
            else if(self.activityData!.cycling){
                return  ""//不取資料
            }
        }
        return ""
    }
    func altitudeDidChange(){   //每次氣壓計Sensor取得新資料，約1s 跑一次此function
      
        var location:CLLocation? = locationManager?.location?
        
        relAltitudeQueue!.append(self.currentAltitudeData!.relativeAltitude.floatValue)  //把目前的氣壓資料加入Queue
        locationQueue!.append(location!.coordinate) // 把目前coordinate加入Queue
        mapAltitudeQueue!.append(Float(location!.altitude))

        var activityString:String = getActivityString() as String
        if(activityString == "")  {
            if(stairsChecking) {
                sendDataToServer(location, activity: activityString)
            }
            return
        }
        
        if(location?.horizontalAccuracy>=10){ // GPS精確度>10m，可能在室內，精確度太低，不取資料
            removeQueueElementAtIndex(0)
            if(stairsChecking) {
                sendDataToServer(location, activity: activityString)
            }
            return  //這次氣壓計變化不取，這次function會在此停止
        }
        
        if(relAltitudeQueue!.count >= 7) {  // Queue 滿
            if(!stairsChecking) {
                var first:Float = relAltitudeQueue!.first! as Float  //抓最前面的
                var last:Float = relAltitudeQueue!.last! as Float  //抓最後面的
                if(abs(first-last)>1.8)
                {
                    stairsChecking = true
                    return
                }   // check
            }else {
                var count = relAltitudeQueue!.count
                var lastThree:Float = relAltitudeQueue![count-3] as Float  //抓倒數第三個
                var lastTwo:Float = relAltitudeQueue![count-2] as Float  //抓倒數第二個
                var last:Float = relAltitudeQueue!.last! as Float  //抓最後面的
                if(abs(last-lastTwo)+abs(lastThree+lastTwo)<0.6){   // 最後兩次變化 < 0.6m 當作 樓梯已結束
                    sendDataToServer(location, activity: activityString)
                    return
                }
                
            }
           
        }   // Queue count
        removeQueueElementAtIndex(0)
    }
    func sendDataToServer(var location:CLLocation?,var activity:String) {
        var first:Float = relAltitudeQueue!.first! as Float  //抓最前面的
        var last:Float = relAltitudeQueue!.last! as Float  //抓最後面的
        
        var date:NSDate = NSDate() //取得現在時間
        var floorIsAscended = "-1"
        if(first>=last){
            floorIsAscended = "0"   //下樓
        }
        else{
            floorIsAscended = "1"    //上樓
        }
        var latitudeArr:Array<Float> = []
        var longitudeArr:Array<Float> = []
        for loc in locationQueue! {
            latitudeArr.append(Float(loc.latitude))
            longitudeArr.append(Float(loc.longitude))
        }
        
        var dict:Dictionary<String,AnyObject> = [
            "latitude":latitudeArr,
            "longitude":longitudeArr,
            "altitude":mapAltitudeQueue!,
            "horizontalAccuracy":location!.horizontalAccuracy,
            "timestamp":date.timeIntervalSince1970,
            "altitudeLog":relAltitudeQueue!,
            "floorIsAscended":floorIsAscended,
            "activity":activity       ]
        
        networkManager!.sendData(dict)
        removeQueueAllElement()
        
        stairsChecking = false
    }
    func removeQueueElementAtIndex(index:Int){
        relAltitudeQueue!.removeAtIndex(index)
        locationQueue!.removeAtIndex(index)
        mapAltitudeQueue!.removeAtIndex(index)
    }
    func removeQueueAllElement() {
        relAltitudeQueue!.removeAll()
        locationQueue!.removeAll()
        mapAltitudeQueue!.removeAll()
    }
    
}
