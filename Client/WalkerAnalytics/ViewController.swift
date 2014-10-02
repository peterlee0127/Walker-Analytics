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
    var locationManager:CLLocationManager?
    @IBOutlet var accuracyLabel:UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        initLocationManaer()
        accuracyLabel!.adjustsFontSizeToFitWidth = true
        // Do any additional setup after loading the view, typically from a nib.
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
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (status==CLAuthorizationStatus.Authorized || status==CLAuthorizationStatus.AuthorizedWhenInUse)  {
           locationManager!.startUpdatingLocation()
            locationManager!.startMonitoringSignificantLocationChanges()
            locationManager!.startUpdatingHeading()
        
        }
        
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var location:CLLocation = locations.first as CLLocation
        accuracyLabel!.text = "horizontal:\(location.horizontalAccuracy)\t vertical:\(location.verticalAccuracy)"
        if(location.horizontalAccuracy<10 || location.verticalAccuracy<10){
            //Accuracy
            
            
            
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

