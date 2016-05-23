//
//  MapViewController.swift
//  WalkerAnalytics
//
//  Created by Peterlee on 11/26/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

extension String {
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
}

class MapViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate,NetworkManagerDelegate {

    @IBOutlet var mapView:MKMapView!
    @IBOutlet var accuracyLabel:UILabel!
    var networkManager:NetworkManager?
    override func viewDidLoad() {
        super.viewDidLoad()

        
        networkManager = NetworkManager.sharedInstance
        networkManager!.delegate = self
        networkManager!.getAnalytics()
       
        CLLocationManager().requestWhenInUseAuthorization()
        
        mapView!.setRegion(MKCoordinateRegionMakeWithDistance(
            CLLocationCoordinate2DMake(25.175358,121.449864), 1500, 1500), animated: false)
        mapView!.pitchEnabled = true
        mapView!.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "accuracyChange:", name: "accuracyChange", object: nil)
        // Do any additional setup after loading the view.
    }
    func downloadComplete(data: Array<[String : AnyObject]>!) {
        for(var i=0;i<data!.count;i += 1) {
            var temp:[String:AnyObject] = data![i] as [String:AnyObject]
            let leng:Array<String> = temp["altitudeLog"]! as! Array<String>
            for(var j=0;j<leng.count;j += 1) {
                    var lat = temp["latitude"]! as! Array<String>
                    var lon = temp["longitude"]! as! Array<String>
                    let latitude = lat[j].toDouble()!
                    let longitude = lon[j].toDouble()!
                    let radius = temp["horizontalAccuracy"]! as! Int
                    let circle:MKCircle = MKCircle(centerCoordinate: CLLocationCoordinate2DMake(latitude,longitude), radius:Double(radius))
                mapView!.addOverlay(circle)
              
            }
        }
        
        
    }
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
//        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.redColor()
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            return circle
//        }
    }
    func accuracyChange(noti:NSNotification) {
        let location:CLLocation = noti.object as! CLLocation
        accuracyLabel!.text = String(format: "%.1fm", location.horizontalAccuracy)
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    } //This is swift code


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
