//
//  PlaceModels.swift
//  OTPBottomSheet
//
//  Created by Manu on 2025-09-17.
//

import Foundation
import MapKit

struct PlaceLocation: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let category: String
    let address: String
    let rating: Double
    let reviewCount: Int
    let coordinate: CLLocationCoordinate2D
    let description: String
    let imageURL: String?
    let isOpen: Bool
    let openingHours: String
    let phoneNumber: String?

    static func == (lhs: PlaceLocation, rhs: PlaceLocation) -> Bool {
        return lhs.id == rhs.id
    }
}

class PlaceAnnotation: NSObject, MKAnnotation {
    let location: PlaceLocation

    var coordinate: CLLocationCoordinate2D {
        return location.coordinate
    }

    var title: String? {
        return location.name
    }

    var subtitle: String? {
        return location.category
    }

    init(location: PlaceLocation) {
        self.location = location
        super.init()
    }
}