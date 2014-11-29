//
//  ViewController.swift
//  WalkerAnalytics
//
//  Created by Peterlee on 10/2/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

import UIKit
import CoreMotion
import MapKit
import CoreLocation
import QuartzCore
import AVFoundation

class ViewController: UITabBarController,CLLocationManagerDelegate,MKMapViewDelegate {
    var locationManager:CLLocationManager?
    var motionManager:MotionManager?
    var acceleroManager:CMMotionManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLocationManaer()
        initMotionManager()
        
        var mapVC:MapViewController = MapViewController(nibName:"MapViewController",bundle:nil)
        mapVC.tabBarItem.title = "地圖"
        
        var settingVC:SettingViewController = SettingViewController(nibName:"SettingViewController",bundle:nil)
        settingVC.tabBarItem.title = "設定"
        
        setViewControllers([mapVC,settingVC], animated: true)
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func initLocationManaer(){
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.requestWhenInUseAuthorization()
        locationManager!.requestAlwaysAuthorization()
        locationManager!.activityType = CLActivityType.Fitness
        locationManager!.distanceFilter = kCLDistanceFilterNone
    }
    func initMotionManager(){
       motionManager = MotionManager.sharedInstance
       motionManager!.locationManager = locationManager!
       motionManager!.startTrackingMotion()
    }
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (status==CLAuthorizationStatus.Authorized || status==CLAuthorizationStatus.AuthorizedWhenInUse)  {
           locationManager!.startUpdatingLocation()
            locationManager!.startMonitoringSignificantLocationChanges()
        }
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var location =  locations.first as CLLocation
        NSNotificationCenter.defaultCenter().postNotificationName("accuracyChange", object: location)
    }
    

}

