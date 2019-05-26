//
//  CadastroViewController.swift
//  HelpCare
//
//  Created by Carlos Doki on 25/05/19.
//  Copyright © 2019 Lucas Dok. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CadastroViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanciaTxt: UITextField!
    @IBOutlet weak var slider: UISlider!
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    
    var route: MKRoute?
    var circle:MKCircle!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        let coordinates = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        circle = MKCircle(center: coordinates, radius: CLLocationDistance(0))
        mapView.addOverlay(circle)
        slider.value = 0
        distanciaTxt.text = "0 KM"
    }
    
    @IBAction func slider(_ sender: Any) {
        mapView.removeOverlay(circle)
        var myIntValue = Int(slider.value)
        let coordinates = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        circle = MKCircle(center: coordinates, radius: CLLocationDistance(myIntValue * 100))
        mapView.addOverlay(circle)
        distanciaTxt.text = "\(myIntValue) KM"
        let viewRegion = MKCoordinateRegion(center: (currentLocation?.coordinate)!, latitudinalMeters: CLLocationDistance(myIntValue*100), longitudinalMeters: CLLocationDistance(myIntValue*100))
        mapView.setRegion(viewRegion, animated: false)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKCircle.self) {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            
                circleRenderer.fillColor = UIColor.red.withAlphaComponent(0.1)
                circleRenderer.strokeColor = UIColor.red
            circleRenderer.lineWidth = 1
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
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
