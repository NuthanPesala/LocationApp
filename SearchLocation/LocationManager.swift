//
//  LocationManager.swift
//  SearchLocation
//
//  Created by Nuthan Raju Pesala on 06/05/21.
//

import Foundation
import CoreLocation

struct Location {
    var title: String
    var coordinates: CLLocationCoordinate2D
}
class LocationManager: NSObject {
    static let shared = LocationManager()
    
    public func findingLocations(with query: String, completion: @escaping (([Location]) -> ())) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(query) { (places, error) in
            guard let places = places, error == nil else {
                completion([])
                return
            }
            let models: [Location] = places.compactMap({ place  in
                var name = ""
                if let placeName = place.name {
                    name = placeName
                }
                if let location = place.locality {
                    name += location
                }
                if let admin = place.administrativeArea {
                    name += ", \(admin)"
                }
                if let country = place.country {
                    name += ", \(country)"
                }
                
                let result = Location(title: name,
                                 coordinates: place.location!.coordinate)
                return result
            })
            completion(models)
        }
    }
}
