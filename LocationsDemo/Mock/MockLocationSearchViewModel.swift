//
//  MockLocationSearchViewModel.swift
//  LocationsDemo
//
//  Created by Marco Alonso Rodriguez on 03/03/25.
//

import SwiftUI
import MapKit

// MARK: - Mock ViewModel para Previsualización
class MockLocationSearchViewModel: LocationSearchProtocol {
    @Published var selectedAnnotation: MKPointAnnotation?

    init() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 19.7035, longitude: -101.1926)
        annotation.title = "Av Morelos 153"
        annotation.subtitle = "Centro, Morelia"
        self.selectedAnnotation = annotation
    }
}


// MARK: - Vista de Previsualización
struct MockLocationSearchView: View {
    @StateObject private var viewModel = MockLocationSearchViewModel()
    
    var body: some View {
        VStack {
            Text("Vista de Prueba")
                .font(.title)
                .padding()

            CustomMapView(viewModel: viewModel)
                .frame(height: 300)
                .cornerRadius(10)
                .padding()
        }
    }
}

// MARK: - Previsualización
struct MockLocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MockLocationSearchView()
    }
}
