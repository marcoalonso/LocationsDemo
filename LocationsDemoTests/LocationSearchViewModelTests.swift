//
//  LocationSearchViewModelTests.swift
//  LocationsDemoTests
//
//  Created by Marco Alonso Rodriguez on 03/03/25.
//

import XCTest
import MapKit
@testable import LocationsDemo // Reemplaza con el nombre de tu app

class LocationSearchViewModelTests: XCTestCase {
    
    var viewModel: LocationSearchViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = LocationSearchViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testSearchQueryUpdatesSuggestions() {
        viewModel.searchQuery = "Av Morelos"
        XCTAssertEqual(viewModel.searchQuery, "Av Morelos", "El query no se actualizó correctamente")
    }
    
    func testMockSearchLocation() {
        let mockViewModel = MockLocationSearchViewModel()
        XCTAssertNotNil(mockViewModel.selectedAnnotation, "La anotación no debería ser nil en Mock")
        XCTAssertEqual(mockViewModel.selectedAnnotation?.title, "Av Morelos 153", "El título de la anotación no es correcto")
    }
    
    func testSearchLocationAddsAnnotation() {
        let mockCompletion = MockSearchCompletion(title: "Av Morelos 153", subtitle: "Centro, Morelia")
        
        viewModel.searchLocationMock(mockCompletion)
        
        let expectation = XCTestExpectation(description: "Esperar a que la anotación se actualice")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertNotNil(self.viewModel.selectedAnnotation, "La anotación no se creó")
            XCTAssertEqual(self.viewModel.selectedAnnotation?.title, "Av Morelos 153", "El título no coincide")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }

}


