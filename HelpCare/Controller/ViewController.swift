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
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    
    
    struct match : Codable {
        let status: Bool
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //        NotificationCenter.default.addObserver(self, name: .postRegisterCallback, object: nil)
        
        mapView.delegate = self
        mapView.isHidden = true
        Alamofire.request("https://lclzk8zkji.execute-api.us-east-1.amazonaws.com/dev/x/disasters/35a317f0-7f46-11e9-b63b-cd64b780f8e3/users/98323510-7f71-11e9-900a-cd5dd7ff5e4a").responseJSON { response in
            if let json = response.data {
                do {
                    let decoder = JSONDecoder()
                    var matchs = try decoder.decode(match.self, from: json as! Data)
                    if matchs.status {
                        
                        
                        self.locationManager = CLLocationManager()
                        self.locationManager.delegate = self
                        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                        
                        // Check for Location Services
                        
                        if CLLocationManager.locationServicesEnabled() {
                            self.locationManager.requestWhenInUseAuthorization()
                            self.locationManager.startUpdatingLocation()
                            self.mapView.showsUserLocation = true
                        }
                        self.mapView.isHidden = false
                    }
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
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
