//
//  LocationService.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 16.06.2022.
//

import MapKit

class LocationService: NSObject {

    static let shared = LocationService()

    private var service = CLLocationManager()
    private var state: CLAuthorizationStatus = .notDetermined
    private var isRunning = false
    private var currentLocation = Observable(LatLng())

    var location: LatLng {
        get { return currentLocation.value }
        set { currentLocation.value = newValue }
    }

    func addObserver(_ observer: AnyObject, closure: @escaping (LatLng, ObservableOptions) -> Void) {
        currentLocation.addObserver(observer, closure: closure)
    }

    func removeObserver(observer: AnyObject) {
        currentLocation.removeObserver(observer)
    }

    override init() {
        super.init()
        service.allowsBackgroundLocationUpdates = true
        service.pausesLocationUpdatesAutomatically = false
        service.desiredAccuracy = kCLLocationAccuracyBest
        service.delegate = self
    }

    func check(_ isEnabledToast: Bool = true) -> Bool {
        switch service.authorizationStatus {
        case .notDetermined:
            service.requestWhenInUseAuthorization()
            return false
        case .restricted, .denied:
            // TODO: message
            return false
        default:
            return true
        }
    }

    func askPermission() {
        switch service.authorizationStatus {
        case .notDetermined:
            service.requestWhenInUseAuthorization()
        default: return
        }
    }

    func start() {
        isRunning = true
        if check(false) {
            service.startUpdatingLocation()
        }
    }

    func stop() {
        isRunning = false
        service.stopUpdatingLocation()
    }
}

// MARK: - Delegate
extension LocationService: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            if isRunning {
                start()
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.location = LatLng(location)

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
}
