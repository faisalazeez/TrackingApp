//
//  TrackingDTOTests.swift
//  TrackingAppTests
//
//  Created by Faisal Azeez on 17/12/2025.

import XCTest
@testable import TrackingApp

class TrackingDTOTests: XCTestCase {
    
    func testTrackingItemDTODecoding() throws {
        // Given
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
        
        // When
        let dto = try JSONDecoder().decode(TrackingItemDTO.self, from: json)
        
        // Then
        XCTAssertEqual(dto.plateNo, "X 19599")
        XCTAssertEqual(dto.driverName, "John Doe")
        XCTAssertEqual(dto.lat, 25.2048)
        XCTAssertEqual(dto.lng, 55.2708)
    }
    
    func testTrackingResponseDTODecoding() throws {
        // Given - API returns direct array
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
        
        // When
        let response = try JSONDecoder().decode(TrackingResponseDTO.self, from: json)
        
        // Then
        XCTAssertEqual(response.count, 1)
        XCTAssertEqual(response[0].plateNo, "X 19599")
    }
    
    func testTrackingItemDTOToDomainConversion() {
        // Given
        let dto = TrackingItemDTO(
            plateNo: "X 19599",
            driverName: "John Doe",
            lat: 25.2048,
            lng: 55.2708,
            location: "Rolla, Sharjah, UAE",
            imageURL: "https://example.com/image.jpg",
            lastUpdated: "2024-12-14T10:30:00.000Z"
        )
        
        // When
        let domain = dto.toDomain()
        
        // Then
        XCTAssertNotNil(domain)
        XCTAssertEqual(domain?.plateNo, "X 19599")
        XCTAssertEqual(domain?.driverName, "John Doe")
        XCTAssertEqual(domain?.latitude, 25.2048)
        XCTAssertEqual(domain?.longitude, 55.2708)
    }
    
    func testTrackingItemDTOWithInvalidDate() {
        // Given
        let dto = TrackingItemDTO(
            plateNo: "X 19599",
            driverName: "John Doe",
            lat: 25.2048,
            lng: 55.2708,
            location: "Rolla, Sharjah, UAE",
            imageURL: "https://example.com/image.jpg",
            lastUpdated: "invalid-date"
        )
        
        // When
        let domain = dto.toDomain()
        
        // Then
        XCTAssertNil(domain, "Should return nil for invalid date format")
    }
}
