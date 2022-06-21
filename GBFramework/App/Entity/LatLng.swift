//
//  LatLng.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 16.06.2022.
//

import Foundation
import MapKit

struct LatLng {
    
    var id: Int
    var lat: Double
    var lng: Double
    
    init(_ id: Int = 0, _ lat: Double, _ lng: Double) {
        self.id = id
        self.lat = lat.fixed6
        self.lng = lng.fixed6
    }
    
    init(_ json: [String:Any]? = nil) {
        self.id = Int(Double(json?["id"]))
        self.lat = Double(json?["lat"]).fixed6
        self.lng = Double(json?["lng"]).fixed6
    }
    
    init(_ coord: CLLocation, id: Int = 0) {
        self.id = id
        self.lat = coord.coordinate.latitude
        self.lng = coord.coordinate.longitude
    }
    
    init(_ latlng: LatLngObject) {
        self.id = latlng.id
        self.lat = latlng.lat
        self.lng = latlng.lng
    }
    
    var isEmpty: Bool {
        get { return lat == 0 && lng == 0 }
    }
    
    func distance(to: LatLng) -> Double {
        return getDistance(self.lat, self.lng, to.lat, to.lng)
    }
    
    func getDistance(_ lat1: Double, _ lng1: Double, _ lat2:Double, _ lng2:Double) -> Double {
        let dLat = deg2rad(lat2 - lat1)
        let dLng = deg2rad(lng2 - lng1)
        let a = pow(sin(dLat / 2), 2) + cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * pow(sin(dLng / 2), 2)
        return Double.earthRadius * 2 * atan2(sqrt(a), sqrt(1 - a))
    }
    
    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
    
    func getJson() -> [String: Any] {
        return [
            "id": id,
            "lat": lat,
            "lng": lng
        ]
    }
}

// MARK: - ==
extension LatLng: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        if lhs.isEmpty && rhs.isEmpty { return true }
        if lhs.isEmpty || rhs.isEmpty { return false }
        return lhs.lat == rhs.lat && lhs.lng == rhs.lng
    }
}

// MARK: - String
extension LatLng {
    
    var toString: String {
        get { return "\(lat.fixed6),\(lng.fixed6)" }
    }
}
