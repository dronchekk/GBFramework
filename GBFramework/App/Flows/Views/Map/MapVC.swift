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
    @IBOutlet private weak var startEndButton: UIButton!
    @IBOutlet private weak var pathButton: UIButton!
    
    // MARK: - Properties
    private let database = DatabaseService()
    private var path = [LatLng]() {
        didSet {
            updatePath()
        }
    }
    private var isProcessing = Observable(false)
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        addObservers()
        updateCenter()
        onProcessing()
        updateData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservers()
    }
    
    // MARK: - Private
    private func configure() {
        mapView.delegate = self
        startEndButton.style = Styles.shared.button.roundDfPr
        pathButton.style = Styles.shared.button.roundSmPr
    }
    
    private func addObservers() {
        addObserversProcessing()
    }
    
    private func removeObservers() {
        removeObserversLocation()
        removeObserversProcessing()
    }

    // MARK: - Data
    func updateData() {
        pathButton.setTitle(Locales.value("vc_map_button_path"), for: .normal)
    }
    
    // MARK: - Map
    private func addAnnotation(_ latlng: LatLng) {
        guard !latlng.isEmpty else { return }
        mapView.addAnnotation(id: mapView.annotations.count, image: UIImage.circle(diameter: 4, color: .red), coord: latlng)
    }
    
    private func updateCenter() {
        let center = self.path.last ?? LocationService.shared.location
        guard !center.isEmpty else { return }
        let showWithAnimation = mapView.annotations.count > 0
        mapView.setVisibleMapRect(center, radius: 2000, animated: showWithAnimation)
    }
    
    // MARK: - Taps
    @IBAction private func onTapStartEnd(_ sender: UIButton) {
        isProcessing.value = !isProcessing.value
    }
    
    @IBAction private func onTapPath(_ sender: UIButton) {
        func readPath() {
            removeObserversProcessing()
            self.isProcessing.value = false
            onProcessing(storePath: false)
            mapView.removeAnnotations(mapView.annotations)
            mapView.removeOverlays(mapView.overlays)
            self.path = database.getPath()
            addObserversProcessing()
            mapView.setVisibleMapRect(self.path,
                                      edgePadding: UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40),
                                      animated: true)
        }
        
        guard !isProcessing.value else {
            let dialog = UIAlertController(
                title: Locales.value("dialog_title_warning"),
                message: Locales.value("dialog_text_beforeShowPathYouHaveToStopLocationObserving"),
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: Locales.value("dialog_button_okStop"),
                style: .default) { _ in
                    readPath()
                }
            dialog.addAction(okAction)
            self.present(dialog, animated: true, completion: nil)
            return
        }
        readPath()
    }
}

// MARK: - Location
extension MapVC: LocationProtocol {
    
    func addObserversLocation() {
        LocationService.shared.addObserver(self) { [weak self] latlng, _ in
            guard let self = self else { return }
            var latlng = latlng
            latlng.id = self.path.count
            self.path.append(latlng)
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MapPolyline {
            let renderer = MKPolylineRenderer(overlay: polyline)
            renderer.strokeColor = polyline.color
            renderer.lineWidth = polyline.width ?? 3
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

// MARK: Path Change
extension MapVC {
    
    private func updatePath() {
        updateAnnotations()
        updateOverlays()
        updateCenter()
    }
    
    private func updateAnnotations() {
        if mapView.annotations.count == 0 {
            self.path.forEach({
                self.addAnnotation($0)
            })
        }
        else if let latlng = path.last {
            self.addAnnotation(latlng)
        }
    }
    
    private func updateOverlays() {
        func addOverlay(from: LatLng, to: LatLng) {
            self.mapView.addOverlay(from: from, to: to, color: Styles.shared.c.mapRoute)
        }
        
        if mapView.overlays.count == 0 {
            guard self.path.count > 0 else { return }
            for index in 0 ..< self.path.count - 1 {
                addOverlay(from: path[index], to: path[index + 1])
            }
        }
        else if path.count > 1 {
            addOverlay(from: path[path.count - 2], to: path[path.count - 1])
        }
    }
}

// MARK: Processing
extension MapVC {
    
    private func addObserversProcessing() {
        isProcessing.addObserver(self) { [weak self] _, _ in
            self?.onProcessing()
        }
    }
    
    private func removeObserversProcessing() {
        isProcessing.removeObserver(self)
    }
    
    private func onProcessing(storePath: Bool = true) {
        if isProcessing.value {
            startEndButton.setTitle(Locales.value("vc_map_button_end"), for: .normal)
            mapView.removeAnnotations(mapView.annotations)
            mapView.removeOverlays(mapView.overlays)
            path.removeAll()
            addObserversLocation()
            LocationService.shared.start()
        }
        else {
            startEndButton.setTitle(Locales.value("vc_map_button_start"), for: .normal)
            removeObserversLocation()
            LocationService.shared.stop()
            if storePath {
                try? database.save(items: path)
            }
        }
    }
}
