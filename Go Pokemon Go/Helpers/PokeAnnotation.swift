//
//  PokeAnnotation.swift
//  Go Pokemon Go
//
//  Created by Emil Vaklinov on 08/05/2020.
//  Copyright © 2020 Emil Vaklinov. All rights reserved.
//

import UIKit
import MapKit

class PokeAnnotation: NSObject, MKAnnotation  {
    var coordinate: CLLocationCoordinate2D
    var pokemon : Pokemon
    
    init(coord:CLLocationCoordinate2D, pokemon:Pokemon) {
        self.coordinate = coord
        self.pokemon = pokemon
    }
}

