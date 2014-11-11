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

class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    // Motion and Location
    var locationManager:CLLocationManager?
    var motionManager:MotionManager?
    var altitudeChangeTimes:Int?
    var reStartTimer:NSTimer?
    //IBOutlet
    @IBOutlet var accuracyLabel:UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        altitudeChangeTimes = 0
        initLocationManaer()
        initMotionManager()
        
        accuracyLabel!.adjustsFontSizeToFitWidth = true
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
        locationManager!.distanceFilter = 1
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
            locationManager!.startUpdatingHeading()
        
        }
        
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var location:CLLocation = locations.first as CLLocation
        accuracyLabel!.text = "horizontal:\(location.horizontalAccuracy)"
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

