//
//  LocationSearchViewModel.swift
//  LocationsDemo
//
//  Created by Marco Alonso Rodriguez on 03/03/25.
//

import SwiftUI

import MapKit

class LocationSearchViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    
    @Published var searchQuery = "" {
        didSet {
            updateSearchQuery()
        }
    }
    @Published var searchResults: [MKLocalSearchCompletion] = []
    @Published var selectedCoordinate: CLLocationCoordinate2D?
    @Published var selectedAnnotation: MKPointAnnotation?

    private var completer = MKLocalSearchCompleter()
    
    override init() {
        super.init()
        completer.delegate = self
        completer.resultTypes = .address
    }
    
    func updateSearchQuery() {
        completer.queryFragment = searchQuery
    }
    
    // MARK: - Manejo de resultados de autocompletado
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async {
            self.searchResults = completer.results
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error en autocompletado: \(error.localizedDescription)")
    }

    // MARK: - Buscar ubicación exacta y agregar marcador
    func searchLocation(_ completion: MKLocalSearchCompletion) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = completion.title

        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let coordinate = response?.mapItems.first?.placemark.coordinate else { return }
            
            DispatchQueue.main.async {
                // Asignar la coordenada seleccionada
                self?.selectedCoordinate = coordinate
                
                // Crear un marcador (MKPointAnnotation)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = completion.title
                annotation.subtitle = completion.subtitle
                
                self?.selectedAnnotation = annotation
                
                // Cerrar el teclado automáticamente
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}
