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
import BMSCore


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var aceitarBtn: RoundedButton!
    @IBOutlet weak var recusarBtn: RoundedButton!
    @IBOutlet weak var usuarioLbl: UILabel!
    @IBOutlet weak var carregandoV: UIView!
    @IBOutlet weak var mensagemV: UIView!
    @IBOutlet weak var naoHaDesastresLbl: UILabel!
    @IBOutlet weak var voluntarioLbl: UILabel!
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    
    
    struct match : Codable {
        let status: Bool
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        carregandoV.isHidden = false
        mensagemV.isHidden = true
        usuarioLbl.text = "Olá \(nome)"
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
        mapView.delegate = self
        mapView.isHidden = true
        aceitarBtn.isHidden = true
        recusarBtn.isHidden = true
        naoHaDesastresLbl.isHidden = true
        
        Alamofire.request("https://lclzk8zkji.execute-api.us-east-1.amazonaws.com/dev/x/disasters/35a317f0-7f46-11e9-b63b-cd64b780f8e3/users/\(idusuario)").responseJSON { response in
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
                        self.aceitarBtn.isHidden = false
                        self.recusarBtn.isHidden = false
                        self.naoHaDesastresLbl.isHidden = false
                    } else {
                        self.naoHaDesastresLbl.isHidden = false
                    }
                    self.carregandoV.isHidden = true
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        }
        
    }
    
    @objc func didBecomeActive(_ notification: Notification) {
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        mensagemV.isHidden = true
        if recusarBtn.isHidden {
            naoHaDesastresLbl.isHidden = false
        }
        
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
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
    
    @IBAction func aceitarPressed(_ sender: Any) {
        naoHaDesastresLbl.isHidden = true
        mensagemV.isHidden = false
        mapView.isHidden = true
        aceitarBtn.isHidden = true
        recusarBtn.isHidden = true
        voluntarioLbl.text = "Obrigado pelo voluntariado"
    }
    
    @IBAction func recusarPressed(_ sender: Any) {
        naoHaDesastresLbl.isHidden = true
        mensagemV.isHidden = false
        mapView.isHidden = true
        aceitarBtn.isHidden = true
        recusarBtn.isHidden = true
        voluntarioLbl.text = "Que pena, mas obrigado pelo voluntariado"
        
    }
}
