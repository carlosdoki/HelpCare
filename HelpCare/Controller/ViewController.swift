//
//  ViewController.swift
//  HelpCare
//
//  Created by Lucas Dok on 25/05/19.
//  Copyright © 2019 Lucas Dok. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        NotificationCenter.default.addObserver(self, name: .postRegisterCallback, object: nil)
//        https://lclzk8zkji.execute-api.us-east-1.amazonaws.com/dev/x/disasters/35a317f0-7f46-11e9-b63b-cd64b780f8e3/users/98323510-7f71-11e9-900a-cd5dd7ff5e4a
        
        mapView.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        }
        
        
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self, name: .postRegisterCallback, object: nil)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { currentLocation = locations.last }
        
        if currentLocation == nil {
            // Zoom to user location
            if let userLocation = locations.last {
                let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
                mapView.setRegion(viewRegion, animated: false)
            }
        }
    }

}


extension Notification.Name {
    static let postRegisterCallback = Notification.Name("postRegisterCallback")
}
