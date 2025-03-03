//
//  LocationSearchUITests.swift
//  LocationsDemoTests
//
//  Created by Marco Alonso Rodriguez on 03/03/25.
//

import XCTest

class LocationSearchUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }

    func testSearchAndSelectLocation() {
        let searchField = app.textFields["Buscar ubicación..."]
        XCTAssertTrue(searchField.exists, "El campo de búsqueda no existe")
        
        // Escribir en el campo de búsqueda
        searchField.tap()
        searchField.typeText("Av Morelos 153")
        
        // Verificar que aparezca una sugerencia (simulación)
        let firstSuggestion = app.buttons["Av Morelos 153, Centro, Morelia"]
        XCTAssertTrue(firstSuggestion.waitForExistence(timeout: 3), "No apareció la sugerencia")
        
        // Seleccionar la dirección
        firstSuggestion.tap()
        
        // Verificar que el mapa se actualizó con la anotación
        let map = app.otherElements["CustomMapView"]
        XCTAssertTrue(map.exists, "El mapa no se actualizó correctamente")
    }
}
