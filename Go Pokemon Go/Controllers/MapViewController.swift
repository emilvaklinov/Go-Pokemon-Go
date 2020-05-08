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
                annoCoord.latitude += (Double.random(in: 0...200) - 100.0) / 30000.0
                annoCoord.longitude += (Double.random(in: 0...200) - 100.0) / 30000.0
                if let pokemon = self.pokemons.randomElement() {
                    let anno = PokeAnnotation(coord: annoCoord, pokemon: pokemon)
                    self.mapView.addAnnotation(anno)
                }
            }
        }
    }
    // Custom annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        if annotation is MKUserLocation {
            annoView.image = UIImage(named: "player")
        } else {
            if let pokeAnnotation = annotation as? PokeAnnotation {
                if let imageName = pokeAnnotation.pokemon.imageName {
                    annoView.image = UIImage(named: imageName)
                }
            }
        }
        var frame = annoView.frame
        frame.size.height = 50.0
        frame.size.width = 50.0
        annoView.frame = frame
        
        return annoView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        if view.annotation is MKUserLocation {
            
        } else {
            if let center =  manager.location?.coordinate {
                if let pokeCenter = view.annotation?.coordinate {
                    let region = MKCoordinateRegion(center: pokeCenter, latitudinalMeters: 200, longitudinalMeters: 200)
                    mapView.setRegion(region, animated: false)
                    
                    if let pokeAnnotation = view.annotation as? PokeAnnotation {
                        
                        if let pokemonName = pokeAnnotation.pokemon.name {
                            if mapView.visibleMapRect.contains(MKMapPoint(center)) {
                                //                            print("YOU COUGHT !")
                                pokeAnnotation.pokemon.caught = true
                                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                                let alertVC = UIAlertController(title: "Congrats!", message: "You caught a \(pokemonName)", preferredStyle: .alert)
                                let pokeDexAlert = UIAlertAction(title: "PokeDex", style: .default) { (action) in
                                    self.performSegue(withIdentifier: "moveToPokedex", sender: nil)
                                }
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertVC.addAction(pokeDexAlert)
                                alertVC.addAction(okAction)
                                present(alertVC, animated: true, completion: nil)
                                
                            } else {
                                //                                print("TOO FAR :(")
                                let alertVC = UIAlertController(title: "Ooops!", message: "You were to far away from this \(pokemonName) to catch it. Try moving closer! ", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertVC.addAction(okAction)
                                present(alertVC, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
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
