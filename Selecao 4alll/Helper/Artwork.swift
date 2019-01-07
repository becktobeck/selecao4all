//
//  Artwork.swift
//  Selecao 4alll
//
//  Created by Fábio Beck Wanderer on 04/01/19.
//  Copyright © 2019 Fábio Beck Wanderer. All rights reserved.
//

import MapKit

// Contém o pin que aparecerá no mapa
class Artwork: NSObject, MKAnnotation {

    let coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        
        super.init()
    }

}
