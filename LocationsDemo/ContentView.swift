//
//  ContentView.swift
//  LocationsDemo
//
//  Created by Marco Alonso Rodriguez on 03/03/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

import SwiftUI
import MapKit

// MARK: - ViewModel para manejar la búsqueda


