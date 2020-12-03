//
//  MapView.swift
//  hackathon
//
//  Created by Timo Blattner on 04.04.20.
//  Copyright © 2020 Timo Blattner. All rights reserved.
//

import SwiftUI
import MapKit
import Foundation
import CoreLocation
import Combine

struct GalleryMap: UIViewRepresentable {
    var galleries: [Gallery]

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        let locationCoordinate = CLLocationCoordinate2D(
        latitude: 47.011352,
        longitude: 8.020354)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: locationCoordinate, span: span)
        
        for gallery in galleries {
            let annotation = MKPointAnnotation()
            annotation.coordinate = gallery.locationCoordinate
            view.addAnnotation(annotation)
        }
        view.isScrollEnabled = false
        view.isPitchEnabled = false
        view.isRotateEnabled = false
        view.isZoomEnabled = false
    }
}

struct MapView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        let locationCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude + 0.005, longitude: coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: locationCoordinate, span: span)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        view.setRegion(region, animated: false)
        view.addAnnotation(annotation)
        view.isScrollEnabled = false
        view.isPitchEnabled = false
        view.isRotateEnabled = false
        view.isZoomEnabled = false
    }
}

class LocationManager: NSObject, ObservableObject {
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    @Published var locationStatus: CLAuthorizationStatus? {
        willSet {
            objectWillChange.send()
        }
    }

    @Published var lastLocation: CLLocation? {
        willSet {
            objectWillChange.send()
        }
    }

    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }

        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }

    }

    let objectWillChange = PassthroughSubject<Void, Never>()

    private let locationManager = CLLocationManager()
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationStatus = status
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.lastLocation = location
    }

}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        //MapView(coordinate: galleryData[0].locationCoordinate)
        GalleryMap(galleries: galleryData)
    }
}
