//
//  LocationSearchView.swift
//  LocationsDemo
//
//  Created by Marco Alonso Rodriguez on 03/03/25.
//

import SwiftUI
import MapKit

struct LocationSearchView: View {
    @StateObject private var viewModel = LocationSearchViewModel()
    
    var body: some View {
        VStack {
            TextField("Buscar ubicación...", text: $viewModel.searchQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            List(viewModel.searchResults, id: \.title) { result in
                Button(action: {
                    viewModel.searchLocation(result)
                }) {
                    VStack(alignment: .leading) {
                        Text(result.title)
                            .font(.headline)
                        Text(result.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            if let _ = viewModel.selectedAnnotation {
                CustomMapView(viewModel: viewModel)
                    .frame(height: 300)
                    .cornerRadius(10)
                    .padding()
            }
        }
    }
}

#Preview {
    LocationSearchView()
}
