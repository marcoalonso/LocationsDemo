//
//  CustomMapView.swift
//  LocationsDemo
//
//  Created by Marco Alonso Rodriguez on 03/03/25.
//

import SwiftUI
import MapKit

struct CustomMapView<T: LocationSearchProtocol>: UIViewRepresentable {
    @ObservedObject var viewModel: T
    
    private let mapView = MKMapView()

    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeAnnotations(mapView.annotations)
        
        if let annotation = viewModel.selectedAnnotation {
            mapView.addAnnotation(annotation)

            let region = MKCoordinateRegion(
                center: annotation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                mapView.setRegion(region, animated: true)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: CustomMapView
        
        init(_ parent: CustomMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !(annotation is MKUserLocation) else { return nil }

            let identifier = "CustomMarker"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            }

            // **Forzar siempre el color azul**
            annotationView?.markerTintColor = .blue
            annotationView?.glyphImage = UIImage(systemName: "mappin.circle.fill")

            return annotationView
        }

    }
}

#Preview {
    CustomMapView(viewModel: MockLocationSearchViewModel())
}

protocol LocationSearchProtocol: ObservableObject {
    var selectedAnnotation: MKPointAnnotation? { get }
}
