//
//  MapViewController.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 10/5/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate {
    func getAdress(adress: String)
}

class MapViewController: UIViewController {
    
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    var locat = CLLocation()
    var delegate: MapViewControllerDelegate?
    
    @IBOutlet weak var finishAddress: UIButton!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configLocalization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLocationEnabled()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if touches.first != nil {
            view.endEditing(true)
        }
    }
    
    @IBAction func addressTFEdDidEnd(_ sender: UITextField) {
        geocoder.geocodeAddressString((sender.text!)) { (placemarks, error) in
            if error != nil {
                print("mapkit error: \(error.debugDescription)")
            }
            
            if placemarks != nil {
                if let placemark = placemarks?.first {
                    let annotation = MKPointAnnotation()
                    annotation.title = self.addressTF.text!
                    annotation.coordinate = placemark.location!.coordinate
                    
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
    }
    
    @IBAction func finishAddressBtnAction(_ sender: UIButton) {
        guard let text = self.addressTF.text else { return }
        delegate?.getAdress(adress: text)
        navigationController?.popViewController(animated: true)
    }
    
    func configLocalization() {
        title = R.string.localizable.orderAddressTitle()
        addressTF.placeholder = R.string.localizable.addressPlaceholder()
        finishAddress.setTitle(R.string.localizable.finishAdressBtn(), for: .normal)
        
    }
    
    func checkLocationEnabled() {
        if !CLLocationManager.locationServicesEnabled() {
            showAlert(title: R.string.localizable.geoLocServiceTitle(), message: R.string.localizable.goToSettingsMessage(), url: URL(string: "App-Prefs:root=LOCATION_SERVICES"))
        } else {
            setUpManager()
            checkAuthorization()
            
        }
    }
    
    func setUpManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        addressTF.delegate = self
        mapView.delegate = self
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    func checkAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            break
        case .denied:
            //Обязательно создать в Info.plist Privace - Location When in use...
            showAlert(title: R.string.localizable.geoLocServiceTitle(), message: R.string.localizable.goToSettingsMessage(), url: URL(string: UIApplication.openSettingsURLString))
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        @unknown default:
            break
        }
    }
    
    func showAlert(title: String, message: String?, url: URL?) {
        //  "App-Prefs:root=LOCATION_SERVICES"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: R.string.localizable.cancelTitle(), style: .cancel, handler: nil))
        alert.addAction((UIAlertAction(title: R.string.localizable.goToSettingsMessage(), style: .default, handler: { (alert) in
            if let url = url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func configAdressTF(locality: String, thoroughfare: String, subLocality: String) {
        DispatchQueue.main.async {
            self.addressTF.text = locality + ", " + thoroughfare + ", " + subLocality
        }
    }
}

extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
            locat = manager.location!
            geocoder.reverseGeocodeLocation(locat) { (placemarks, error) in
                if error != nil {
                    print("error")
                    return
                }
                guard let pm = placemarks else {
                    print ("No placemark")
                    return
                }
                
                if pm.count > 0 {
                    var locality = ""
                    var thoroughfare = ""
                    var subLocality = ""
                    
                    if pm[0].locality != nil {
                        locality = pm[0].locality!
                    }
                    if pm[0].thoroughfare != nil {
                        thoroughfare = pm[0].thoroughfare!
                    }
                    if pm[0].subLocality != nil {
                        subLocality = pm[0].subLocality!
                    }
                    self.configAdressTF(locality: locality, thoroughfare: thoroughfare, subLocality: subLocality)
                    manager.stopUpdatingLocation()

                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorization()
    }
}

extension MapViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension MapViewController: UIGestureRecognizerDelegate {
    
    @objc func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        mapView.removeAnnotations(mapView.annotations)
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        //let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        let loc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
   
        geocoder.reverseGeocodeLocation(loc) { (placemarks, error) in
            if error != nil {
                print("error")
                return
            }
            guard let pm = placemarks else {
                print ("No placemark")
                return
            }
            
            if pm.count > 0 {
                var locality = ""
                var thoroughfare = ""
                var subLocality = ""
                
                if pm[0].locality != nil {
                    locality = pm[0].locality!
                }
                if pm[0].thoroughfare != nil {
                    thoroughfare = pm[0].thoroughfare!
                }
                if pm[0].subLocality != nil {
                    subLocality = pm[0].subLocality!
                }
                self.configAdressTF(locality: locality, thoroughfare: thoroughfare, subLocality: subLocality)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = locality
                annotation.subtitle = thoroughfare + ", " + subLocality
                self.mapView.addAnnotation(annotation)
            }
        }
    }
}
