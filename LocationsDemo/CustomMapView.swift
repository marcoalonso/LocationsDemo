//
//  CustomMapView.swift
//  LocationsDemo
//
//  Created by Marco Alonso Rodriguez on 03/03/25.
//

import SwiftUI
import MapKit

struct CustomMapView: UIViewRepresentable {
    @ObservedObject var viewModel: LocationSearchViewModel
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Remover anotaciones previas
        mapView.removeAnnotations(mapView.annotations)
        
        // Agregar la nueva anotación si existe
        if let annotation = viewModel.selectedAnnotation {
            mapView.addAnnotation(annotation)
            
            // Centrar el mapa en la nueva anotación
            let region = MKCoordinateRegion(
                center: annotation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            mapView.setRegion(region, animated: true)
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
        
        // Personalizar el marcador en el mapa
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !(annotation is MKUserLocation) else { return nil }
            
            let identifier = "CustomMarker"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                
                // Personalizar el color del marcador
                if let markerView = annotationView as? MKMarkerAnnotationView {
                    markerView.markerTintColor = .blue
                    markerView.glyphImage = UIImage(systemName: "mappin.circle.fill")
                }
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
    }
}

#Preview {
    CustomMapView(viewModel: LocationSearchViewModel())
}
