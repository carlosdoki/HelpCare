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
import Alamofire
import WSTagsField

class CadastroViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    fileprivate let tagsField = WSTagsField()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanciaTxt: UITextField!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var nomeTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var telefoneTxt: UITextField!
    @IBOutlet weak var usuariolbl: UILabel!
    @IBOutlet weak var tagsView: UIView!
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    
    var route: MKRoute?
    var circle:MKCircle!
    
    struct User : Codable {
        let id: String
        let name: String
        let skills: String
        let email : String
        let distancia : Int
        let telefone: String
        let latitude : Float
        let longitude : Float
        let updatedAt: Int
    }

    
    //var users = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tagsField.frame = tagsView.bounds
        tagsView.addSubview(tagsField)
        
        tagsField.cornerRadius = 3.0
        tagsField.spaceBetweenLines = 10
        tagsField.spaceBetweenTags = 10
        
        tagsField.numberOfLines = 5
        //tagsField.maxHeight = 100.0
        tagsField.layoutMargins = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        tagsField.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) //old padding
        //tagsField.placeholder = "Enter a tag"
//        tagsField.placeholderColor = .red
//        tagsField.placeholderAlwaysVisible = true
        tagsField.backgroundColor = UIColor(red:1.00, green:0.60, blue:0.23, alpha:1.0)
        tagsField.returnKeyType = .next
        tagsField.delimiter = ""
        tagsField.keyboardAppearance = .dark
        tagsField.text = "Conhecimento"
        
//        tagsField.textDelegate = self

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
        slider.value = 0
        distanciaTxt.text = "0 KM"

        Alamofire.request("https://lclzk8zkji.execute-api.us-east-1.amazonaws.com/dev/x/users/98323510-7f71-11e9-900a-cd5dd7ff5e4a").responseJSON { response in
                if let json = response.data {
                    do {
                    let decoder = JSONDecoder()
                        var users = try decoder.decode(User.self, from: json as! Data)
                        self.nomeTxt.text = users.name
                        self.emailTxt.text = users.email
                        self.telefoneTxt.text = users.telefone
                        self.distanciaTxt.text = "\(users.distancia) KM"
                        self.usuariolbl.text = "Olá \(users.name)"
                        self.slider.value = Float(users.distancia)
                        var skills = users.skills.components(separatedBy: ",")
                        for skill in skills {
                            self.tagsField.addTag(skill)
                        }
                        let coordinates = CLLocationCoordinate2D(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
                        self.circle = MKCircle(center: coordinates, radius: CLLocationDistance(0))
                        self.mapView.addOverlay(self.circle)
                        let viewRegion = MKCoordinateRegion(center: coordinates, latitudinalMeters: CLLocationDistance(users.distancia*100), longitudinalMeters: CLLocationDistance(users.distancia*100))
                        self.mapView.setRegion(viewRegion, animated: false)

                    } catch let parsingError {
                        print("Error", parsingError)
                    }
                }
            }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //tagsField.beginEditing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tagsField.frame = tagsView.bounds
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
        var myIntValue = Int(slider.value)
        
        if currentLocation == nil {
            // Zoom to user location
            if let userLocation = locations.last {
                let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: CLLocationDistance(myIntValue*100), longitudinalMeters: CLLocationDistance(myIntValue*100))
                mapView.setRegion(viewRegion, animated: false)
            }
        }
    }

}
