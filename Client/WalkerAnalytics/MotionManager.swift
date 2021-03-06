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
        super.init()
        
        activityManager = CMMotionActivityManager()
        altimeter = CMAltimeter()
        pedometer = CMPedometer()
        relAltitudeQueue = []
        locationQueue = []
        networkManager = NetworkManager.sharedInstance
       

    }
    func startTrackingMotion(){
        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter!.startRelativeAltitudeUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {  (data:CMAltitudeData?, error) in
                if error == nil && data != nil {
                  self.currentAltitudeData = data
                }
            })
        }
      
        if CMPedometer.isStepCountingAvailable() {
        
        }
        if CMMotionActivityManager.isActivityAvailable() {
            activityManager!.startActivityUpdatesToQueue(NSOperationQueue(), withHandler: { (activity:CMMotionActivity?) -> Void in
                    if activity != nil {
                        self.activityData = activity
                    }
                })       // activity block end
        }
        
    }
    func getActivityString() ->String? {
        if(self.activityData != nil){
            if(self.activityData!.walking)  {
//                restartLocationManager()
                return "走路"
            }else if(self.activityData!.running){
//                restartLocationManager()
                return nil   //不取資料
            }
            else {
//                stopLocationManager()
                return nil
            }
        }else {
            return nil
        }
    }
    func restartLocationManager() {
        locationManager!.startMonitoringSignificantLocationChanges()
        locationManager!.startUpdatingLocation()
    }
    func stopLocationManager() {
        locationManager!.stopMonitoringSignificantLocationChanges()
        locationManager!.stopUpdatingLocation()
    }
    func altitudeDidChange(){   //每次氣壓計Sensor取得新資料，約1s 跑一次此function
        let activityString:String? = getActivityString() as String?
        if(activityString == nil)  {
            removeQueueFirstElement()
            if(stairsChecking) {
                sendDataToServer("走路")
            }
            return
        }
        let location:CLLocation? = locationManager?.location
        if(location==nil){
            return
        }
        
        relAltitudeQueue!.append(self.currentAltitudeData!.relativeAltitude.floatValue)  //把目前的氣壓資料加入Queue
        locationQueue!.append(location!.coordinate) // 把目前coordinate加入Queue
     
        if(location?.horizontalAccuracy>=10){ // GPS精確度>10m，可能在室內，精確度太低，不取資料
            removeQueueFirstElement()
            if(stairsChecking) {
                sendDataToServer(activityString!)
            }
            return  //這次氣壓計變化不取，這次function會在此停止
        }
            if(!stairsChecking) {
                let count = relAltitudeQueue!.count
                if(count<4) {
                    return
                }
                let lastFour:Float = relAltitudeQueue![count-4] as Float
                let lastThree:Float = relAltitudeQueue![count-3] as Float  //抓倒數第三個
                let lastTwo:Float = relAltitudeQueue![count-2] as Float  //抓倒數第二個
                let last:Float = relAltitudeQueue!.last! as Float  //抓最後面的
                let compare:Float = abs(last-lastTwo)+abs(lastThree-lastTwo)+abs(lastFour-lastThree)
                if(compare>1.2)  {
                    stairsChecking = true
                }else{
                    removeQueueFirstElement()
                }   // check
            }else {
                let count = relAltitudeQueue!.count
                let lastThree:Float = relAltitudeQueue![count-3] as Float  //抓倒數第三個
                let lastTwo:Float = relAltitudeQueue![count-2] as Float  //抓倒數第二個
                let last:Float = relAltitudeQueue!.last! as Float  //抓最後面的
                if(abs(last-lastTwo)+abs(lastThree-lastTwo)<0.6)    {// 最後兩次變化 < 0.6m 當作 樓梯已結束
                    removeQueueLastElement()
                    removeQueueLastElement()
                    sendDataToServer(activityString!)
                }
            }
    }
    func sendDataToServer( activity:String) {
        let first:Float = relAltitudeQueue!.first! as Float  //抓最前面的
        let last:Float = relAltitudeQueue!.last! as Float  //抓最後面的
        
        let date:NSDate = NSDate() //取得現在時間
        var floorIsAscended = "-1"
        if(first>=last) {
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
        
        let dict:Dictionary<String,AnyObject> = [
            "algorithmVer":"0",
            "latitude":latitudeArr,
            "longitude":longitudeArr,
            "horizontalAccuracy":5,
            "timestamp":date.timeIntervalSince1970,
            "altitudeLog":relAltitudeQueue!,
            "floorIsAscended":floorIsAscended,
            "activity":activity         ]
        
        networkManager!.sendData(dict)
        removeQueueAllElement()
        stairsChecking = false
    }
    func removeQueueFirstElement(){
        if(relAltitudeQueue!.count>0){
            relAltitudeQueue!.removeAtIndex(0)
            locationQueue!.removeAtIndex(0)
        }
    }
    func removeQueueAllElement() {
            relAltitudeQueue!.removeAll()
            locationQueue!.removeAll()
    }
    func removeQueueLastElement(){
        if(relAltitudeQueue!.count>0) {
            relAltitudeQueue!.removeLast()
            locationQueue!.removeLast()
        }
    }
    
}
