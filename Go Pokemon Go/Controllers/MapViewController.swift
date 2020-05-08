//
//  MapViewController.swift
//  Go Pokemon Go
//
//  Created by Emil Vaklinov on 07/05/2020.
//  Copyright © 2020 Emil Vaklinov. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var manager = CLLocationManager()
    var updateCount = 0
    var pokemons : [Pokemon] = []
    
    @IBOutlet weak var mapView: MKMapView!
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Getting the pokemons
        pokemons = getAllPokemon()
        
        manager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            setup()
        }else{
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            setup()
        }
    }
    
    // Showing the users location
    func setup() {
        mapView.showsUserLocation = true
        manager.stopUpdatingLocation()
        mapView.delegate = self
        
        // Creating pokemons every 5 secunds
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            if let center = self.manager.location?.coordinate {
                var annoCoord = center
                annoCoord.latitude += (Double.random(in: 0...200) - 100.0) / 5000.0
                annoCoord.longitude += (Double.random(in: 0...200) - 100.0) / 5000.0
                if let pokemon = self.pokemons.randomElement() {
                    
                }
            }
        }
    }
    // Custom annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        if annotation is MKUserLocation {
            annoView.image = UIImage(named: "player")
            var frame = annoView.frame
            frame.size.height = 50.0
            frame.size.width = 50.0
            annoView.frame = frame
            
            
        }
        return annoView
    }
    
// To follow the location of the user when is moving
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        if updateCount < 3 {
            if let center = manager.location?.coordinate {
                let region = MKCoordinateRegion(center: center, latitudinalMeters: 200, longitudinalMeters: 200)
                mapView.setRegion(region, animated: false)
            }
            updateCount += 1
        } else {
            manager.stopUpdatingLocation()
        }

    }
    
    @IBAction func centerTapped(_ sender: Any) {
        if let center = manager.location?.coordinate {
            let region = MKCoordinateRegion(center: center, latitudinalMeters: 200, longitudinalMeters: 200)
            mapView.setRegion(region, animated: true)
        }
    }
    
}
