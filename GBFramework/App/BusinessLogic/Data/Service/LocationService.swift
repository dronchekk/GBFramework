//
//  LocationService.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 16.06.2022.
//

import MapKit
import RxSwift
import RxCocoa
import RxRelay

class LocationService: NSObject {
    
    static let shared = LocationService()
    
    private var service = CLLocationManager()
    private var state: CLAuthorizationStatus = .notDetermined
    private var isRunning = false
//    private var currentLocationCustomObservable = CustomObservable(LatLng())

    // MARK: - Rx
    private var currentLocationRelay = ReplayRelay<LatLng>.create(bufferSize: 1)
    lazy var currentLocation: Observable<LatLng> = self.currentLocationRelay.asObservable().share()

//    var location: LatLng {
//        get { return currentLocation.value }
//        set { currentLocation.value = newValue }
//    }
    
//    func addObserver(_ observer: AnyObject, closure: @escaping (LatLng, CustomObservableOptions) -> Void) {
//        currentLocation.addObserver(observer, closure: closure)
//    }
//
//    func removeObserver(observer: AnyObject) {
//        currentLocation.removeObserver(observer)
//    }
    
    override init() {
        super.init()
        service.allowsBackgroundLocationUpdates = true
        service.pausesLocationUpdatesAutomatically = false
        service.startMonitoringSignificantLocationChanges()
        service.desiredAccuracy = kCLLocationAccuracyBest
        service.delegate = self
    }
    
    func check(_ isEnabledToast: Bool = true) -> Bool {
        let status = CLLocationManager.authorizationStatus()
        switch status {
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
        let status = CLLocationManager.authorizationStatus()
        switch status {
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

    func getLastLocation() -> Observable<LatLng>{
            return currentLocation
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
//        self.location = LatLng(location)
        currentLocationRelay.accept(LatLng(location))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
}
