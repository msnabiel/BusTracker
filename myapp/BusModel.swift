//
//  BusModel.swift
//  myapp
//
//  Created by Syed Nabiel Hasaan M on 26/05/24.
//

import Foundation
import SwiftUI
import CoreLocation

// Bus model to store bus details
struct Bus {
    let number: String // Bus number
    let driverName: String // Name of the driver
    let contactNumber: String // Contact number of the driver
    var currentLocation: CLLocationCoordinate2D? // Current location of the bus
    
    // Initialize bus with basic details
    init(number: String, driverName: String, contactNumber: String) {
        self.number = number
        self.driverName = driverName
        self.contactNumber = contactNumber
    }
}

// Data manager to handle bus data
class BusManager: ObservableObject {
    // Published property to automatically update views when buses change
    @Published var buses: [Bus] = []
    
    // Function to load bus data from Excel sheet (simulated)
    func loadBusesFromExcel() {
        // In a real app, you would load data from an Excel sheet or any other source
        // For the sake of this example, we'll populate buses with dummy data
        
        // Dummy bus data
        let bus1 = Bus(number: "101", driverName: "John Doe", contactNumber: "1234567890")
        let bus2 = Bus(number: "102", driverName: "Jane Smith", contactNumber: "0987654321")
        
        // Append buses to the array
        buses.append(bus1)
        buses.append(bus2)
    }
}
