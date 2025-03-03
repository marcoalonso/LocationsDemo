//
//  CustomMapViewTests.swift
//  LocationsDemoTests
//
//  Created by Marco Alonso Rodriguez on 03/03/25.
//

import XCTest
import MapKit
import SwiftUI
import UIKit

@testable import LocationsDemo  // Reemplázalo con el nombre de tu app

class CustomMapViewTests: XCTestCase {

    var mockViewModel: MockLocationSearchViewModel!
    var customMapView: CustomMapView<MockLocationSearchViewModel>!
    var context: UIViewRepresentableContext<CustomMapView<MockLocationSearchViewModel>>!
    
    override func setUp() {
        super.setUp()
        mockViewModel = MockLocationSearchViewModel()
        customMapView = CustomMapView(viewModel: mockViewModel)
        let context = customMapView.makeCoordinator()
    }

    override func tearDown() {
        mockViewModel = nil
        customMapView = nil
        context = nil
        super.tearDown()
    }

    // MARK: - 1️⃣ Test: Crear MKMapView correctamente
    func testMakeUIView() {
        let mapView = customMapView.makeUIView(context: context)
        XCTAssertNotNil(mapView, "MKMapView no fue creado correctamente")
        XCTAssertTrue(mapView.delegate is CustomMapView<MockLocationSearchViewModel>.Coordinator, "El delegado del mapa no es un Coordinator válido")
    }

    // MARK: - 2️⃣ Test: Actualizar UI con nueva anotación
    func testUpdateUIViewAddsAnnotation() {
        let mapView = customMapView.makeUIView(context: context)
        
        // Simular cambio de anotación en el ViewModel
        mockViewModel.selectedAnnotation = MKPointAnnotation()
        mockViewModel.selectedAnnotation?.coordinate = CLLocationCoordinate2D(latitude: 19.7035, longitude: -101.1926)
        
        customMapView.updateUIView(mapView, context: context)
        
        XCTAssertEqual(mapView.annotations.count, 1, "El mapa debería tener exactamente una anotación")
        XCTAssertEqual(mapView.annotations.first?.coordinate.latitude, 19.7035, "La coordenada no coincide")
    }
    
    // MARK: - 3️⃣ Test: Se eliminan anotaciones previas antes de agregar nuevas
    func testUpdateUIViewRemovesPreviousAnnotations() {
        let mapView = customMapView.makeUIView(context: context)
        
        // Agregar una primera anotación
        let firstAnnotation = MKPointAnnotation()
        firstAnnotation.coordinate = CLLocationCoordinate2D(latitude: 19.7035, longitude: -101.1926)
        mockViewModel.selectedAnnotation = firstAnnotation
        customMapView.updateUIView(mapView, context: context)
        
        // Cambiar a una nueva anotación
        let secondAnnotation = MKPointAnnotation()
        secondAnnotation.coordinate = CLLocationCoordinate2D(latitude: 19.5, longitude: -101.0)
        mockViewModel.selectedAnnotation = secondAnnotation
        customMapView.updateUIView(mapView, context: context)
        
        XCTAssertEqual(mapView.annotations.count, 1, "El mapa debería tener solo una anotación activa")
        XCTAssertEqual(mapView.annotations.first?.coordinate.latitude, 19.5, "La coordenada no coincide con la segunda anotación")
    }
    
    // MARK: - 4️⃣ Test: Se actualiza la región con animación
    func testUpdateUIViewUpdatesRegion() {
        let mapView = customMapView.makeUIView(context: context)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 19.7035, longitude: -101.1926)
        mockViewModel.selectedAnnotation = annotation
        
        customMapView.updateUIView(mapView, context: context)
        
        let expectedRegion = MKCoordinateRegion(
            center: annotation.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        
        XCTAssertEqual(mapView.region.center.latitude, expectedRegion.center.latitude, accuracy: 0.001, "La región no se actualizó correctamente")
        XCTAssertEqual(mapView.region.center.longitude, expectedRegion.center.longitude, accuracy: 0.001, "La región no se actualizó correctamente")
    }

    // MARK: - 5️⃣ Test: Se crea el Coordinator correctamente
    func testMakeCoordinator() {
        let coordinator = customMapView.makeCoordinator()
        XCTAssertNotNil(coordinator, "El Coordinator no fue creado correctamente")
    }

    // MARK: - 6️⃣ Test: Se configuran correctamente las anotaciones personalizadas
    func testMapViewAnnotationViewIsCustomized() {
        let mapView = customMapView.makeUIView(context: context)
        let coordinator = customMapView.makeCoordinator()
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 19.7035, longitude: -101.1926)
        
        let annotationView = coordinator.mapView(mapView, viewFor: annotation) as? MKMarkerAnnotationView
        
        XCTAssertNotNil(annotationView, "No se creó una MKMarkerAnnotationView")
        XCTAssertEqual(annotationView?.markerTintColor, .blue, "El color del marcador no es azul")
        XCTAssertEqual(annotationView?.reuseIdentifier, "CustomMarker", "El identificador del marcador no es correcto")
    }

    // MARK: - 7️⃣ Test: Se mantiene el color azul para todas las anotaciones
    func testMapViewEnsuresAnnotationsAreAlwaysBlue() {
        let mapView = customMapView.makeUIView(context: context)
        let coordinator = customMapView.makeCoordinator()
        
        let firstAnnotation = MKPointAnnotation()
        firstAnnotation.coordinate = CLLocationCoordinate2D(latitude: 19.7035, longitude: -101.1926)
        
        let secondAnnotation = MKPointAnnotation()
        secondAnnotation.coordinate = CLLocationCoordinate2D(latitude: 19.5, longitude: -101.0)
        
        let firstView = coordinator.mapView(mapView, viewFor: firstAnnotation) as? MKMarkerAnnotationView
        let secondView = coordinator.mapView(mapView, viewFor: secondAnnotation) as? MKMarkerAnnotationView
        
        XCTAssertEqual(firstView?.markerTintColor, .blue, "La primera anotación no es azul")
        XCTAssertEqual(secondView?.markerTintColor, .blue, "La segunda anotación no es azul")
    }
}

