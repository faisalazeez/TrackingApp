//
//  TrackingItemTests.swift
//  TrackingAppTests
//
//  Created by Faisal Azeez on 17/12/2025.

import XCTest
import CoreLocation
@testable import TrackingApp

class TrackingItemTests: XCTestCase {
    
    func testTrackingItemInitialization() {
        let id = "123"
        let plateNo = "X 19599"
        let driverName = "John Doe"
        let location = "Rolla, Sharjah, UAE"
        let lastUpdated = Date()
        
        let item = TrackingItem(
            id: id,
            plateNo: plateNo,
            driverName: driverName,
            location: location,
            latitude: 25.2048,
            longitude: 55.2708,
            lastUpdated: lastUpdated,
            driverImageURL: nil
        )
        
        XCTAssertEqual(item.id, id)
        XCTAssertEqual(item.plateNo, plateNo)
        XCTAssertEqual(item.driverName, driverName)
        XCTAssertEqual(item.location, location)
    }
    
    func testCoordinateProperty() {
        let item = TrackingItem(
            id: "1",
            plateNo: "X 19599",
            driverName: "John Doe",
            location: "Dubai",
            latitude: 25.2048,
            longitude: 55.2708,
            lastUpdated: Date(),
            driverImageURL: nil
        )
        
        let coordinate = item.coordinate
        
        XCTAssertEqual(coordinate.latitude, 25.2048)
        XCTAssertEqual(coordinate.longitude, 55.2708)
    }
    
    func testLastUpdatedFormatting() {
        let todayItem = TrackingItem(
            id: "1",
            plateNo: "X 19599",
            driverName: "John Doe",
            location: "Dubai",
            latitude: 25.2048,
            longitude: 55.2708,
            lastUpdated: Date(),
            driverImageURL: nil
        )
        
        XCTAssertEqual(todayItem.lastUpdatedFormatted, "Today")
        
        let oneDayAgo = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let yesterdayItem = TrackingItem(
            id: "2",
            plateNo: "Y 12345",
            driverName: "Jane Doe",
            location: "Sharjah",
            latitude: 25.3,
            longitude: 55.3,
            lastUpdated: oneDayAgo,
            driverImageURL: nil
        )
        
        XCTAssertEqual(yesterdayItem.lastUpdatedFormatted, "1 day ago")
    }
}
