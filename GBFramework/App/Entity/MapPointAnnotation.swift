//
//  MapPointAnnotation.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 16.06.2022.
//

import UIKit
import MapKit

class MapPointAnnotation: MKPointAnnotation {

    var customType: String?
    var customId: Int?
    var group: String?
    var image: UIImage?
}
