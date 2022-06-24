//
//  LatLngObject.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 18.06.2022.
//

import Foundation
import RealmSwift

class LatLngObject: Object, Codable {

     @Persisted (primaryKey: true) var id: Int = 0
     @Persisted var lat: Double
     @Persisted var lng: Double

     enum CodingKeys: String, CodingKey {
         case id
         case lat, lng
     }

     required convenience init(from decoder: Decoder) throws {
         self.init()
         let container = try decoder.container(keyedBy: CodingKeys.self)
         self.id = try container.decode(Int.self, forKey: .id)
         self.lat = try container.decode(Double.self, forKey: .lat)
         self.lng = try container.decode(Double.self, forKey: .lng)
     }

     convenience init(_ latlng: LatLng) {
         self.init()
         self.id = latlng.id
         self.lat = latlng.lat
         self.lng = latlng.lng
     }
 }
