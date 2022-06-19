//
//  MapVC.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 16.06.2022.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var mapView: MKMapView!

    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        addObservers()

        addAnnotation(LocationService.shared.location)
        updateCenter()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservers()
    }

    // MARK: - Private
    private func configure() {
        mapView.delegate = self
    }

    private func addObservers() {
        addObserversLocation()
    }

    private func removeObservers() {
        removeObserversLocation()
    }

    // MARK: - Map
    private func addAnnotation(_ latlng: LatLng) {
        guard !latlng.isEmpty else { return }
        mapView.addAnnotation(id: mapView.annotations.count, image: UIImage.circle(diameter: 4, color: .red), coord: latlng)
    }

    private func updateCenter() {
        guard !LocationService.shared.location.isEmpty else { return }
        let showWithAnimation = mapView.annotations.count > 0
        mapView.setVisibleMapRect(LocationService.shared.location, radius: 2000, animated: showWithAnimation)
    }
}

// MARK: - Location
extension MapVC: LocationProtocol {

    func addObserversLocation() {
        LocationService.shared.addObserver(self) { [weak self] latlng, _ in
            self?.addAnnotation(latlng)
            self?.updateCenter()
        }
    }

    func removeObserversLocation() {
        LocationService.shared.removeObserver(observer: self)
    }
}

// MARK: - Map Delegate
extension MapVC: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let mapAnnotation = annotation as? MapPointAnnotation {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: mapAnnotation.customType)
            annotationView.canShowCallout = false
            annotationView.image = mapAnnotation.image
            annotationView.centerOffset = CGPoint(x: 0, y: -2)
            return annotationView
        }
        return nil
    }
}
