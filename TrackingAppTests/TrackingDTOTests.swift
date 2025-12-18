//
//  TrackingDTOTests.swift
//  TrackingAppTests
//
//  Created by Faisal Azeez on 17/12/2025.

import XCTest
@testable import TrackingApp

class TrackingDTOTests: XCTestCase {
    
    func testTrackingItemDTODecoding() throws {
        let json = """
        {
            "plateNo": "X 19599",
            "driverName": "John Doe",
            "lat": 25.2048,
            "lng": 55.2708,
            "location": "Rolla, Sharjah, UAE",
            "imageURL": "https://example.com/image.jpg",
            "lastUpdated": "2024-12-14T10:30:00.000Z"
        }
        """.data(using: .utf8)!
        
        let dto = try JSONDecoder().decode(TrackingItemDTO.self, from: json)
        
        XCTAssertEqual(dto.plateNo, "X 19599")
        XCTAssertEqual(dto.driverName, "John Doe")
        XCTAssertEqual(dto.lat, 25.2048)
        XCTAssertEqual(dto.lng, 55.2708)
    }
    
    func testTrackingResponseDTODecoding() throws {
        let json = """
        [
            {
                "plateNo": "X 19599",
                "driverName": "John Doe",
                "lat": 25.2048,
                "lng": 55.2708,
                "location": "Rolla, Sharjah, UAE",
                "imageURL": "https://example.com/image.jpg",
                "lastUpdated": "2024-12-14T10:30:00.000Z"
            }
        ]
        """.data(using: .utf8)!
        
        let response = try JSONDecoder().decode(TrackingResponseDTO.self, from: json)
        
        XCTAssertEqual(response.count, 1)
        XCTAssertEqual(response[0].plateNo, "X 19599")
    }
    
    func testTrackingItemDTOToDomainConversion() {
        let dto = TrackingItemDTO(
            plateNo: "X 19599",
            driverName: "John Doe",
            lat: 25.2048,
            lng: 55.2708,
            location: "Rolla, Sharjah, UAE",
            imageURL: "https://example.com/image.jpg",
            lastUpdated: "2024-12-14T10:30:00.000Z"
        )
        
        let domain = dto.toDomain()
        
        XCTAssertNotNil(domain)
        XCTAssertEqual(domain?.plateNo, "X 19599")
        XCTAssertEqual(domain?.driverName, "John Doe")
        XCTAssertEqual(domain?.latitude, 25.2048)
        XCTAssertEqual(domain?.longitude, 55.2708)
    }
    
    func testTrackingItemDTOWithInvalidDate() {
        let dto = TrackingItemDTO(
            plateNo: "X 19599",
            driverName: "John Doe",
            lat: 25.2048,
            lng: 55.2708,
            location: "Rolla, Sharjah, UAE",
            imageURL: "https://example.com/image.jpg",
            lastUpdated: "invalid-date"
        )
        
        let domain = dto.toDomain()
        
        XCTAssertNil(domain, "Should return nil for invalid date format")
    }
}
