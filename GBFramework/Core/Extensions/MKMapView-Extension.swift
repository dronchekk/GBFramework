//
//  MKMapView-Extension.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 16.06.2022.
//

import MapKit

// MARK: - Annotation
extension MKMapView {

    func addAnnotation(type: String = "", id: Int, image: UIImage?, coord: LatLng, title: String? = nil, group: String? = nil) {
        if coord.isEmpty { return }
        var annotation = self.annotations.first(where: { ($0 as? MapPointAnnotation)?.customType == type && ($0 as? MapPointAnnotation)?.customId == id }) as? MapPointAnnotation
        if annotation == nil {
            annotation = MapPointAnnotation()
            annotation?.customType = type
            annotation?.customId = id
            annotation?.image = image
            annotation?.group = group
            annotation?.title = title
        }
        annotation?.coordinate = CLLocationCoordinate2D(latitude: coord.lat, longitude: coord.lng)
        self.addAnnotation(annotation!)
    }
}

// MARK: - Map Bounds
extension MKMapView {

    func setVisibleMapRect(_ points: [LatLng], edgePadding: UIEdgeInsets? = nil, animated: Bool = true) {
        if let rect = self.getMapRect(points: points) {
            if let edgePadding = edgePadding {
                self.setVisibleMapRect(rect, edgePadding: edgePadding, animated: animated)
            }
            else {
                self.setVisibleMapRect(rect, animated: animated)
            }
        }
    }

    func setVisibleMapRect(_ latlng: LatLng, radius: Double, animated: Bool = true) {
        if latlng.isEmpty { return }
        let location = CLLocation(latitude: latlng.lat, longitude: latlng.lng)
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        self.setRegion(coordinateRegion, animated: animated)
    }

    private func getMapRect(points: [LatLng]) -> MKMapRect? {
        let points = points.filter({ !$0.isEmpty })
        if points.count == 0 { return nil }
        let neLat = points.map({ $0.lat }).max()!
        let neLng = points.map({ $0.lng }).max()!
        let swLat = points.map({ $0.lat }).min()!
        let swLng = points.map({ $0.lng }).min()!
        let ne = MKMapPoint(CLLocationCoordinate2D(latitude: neLat, longitude: neLng))
        let sw = MKMapPoint(CLLocationCoordinate2D(latitude: swLat, longitude: swLng))
        return MKMapRect(x: fmin(ne.x, sw.x), y: fmin(ne.y, sw.y), width: fabs(ne.x - sw.x), height: fabs(ne.y - sw.y))
    }
}
