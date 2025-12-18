//
//  DefaultTrackingRepositoryTests.swift
//  TrackingAppTests
//
//  Created by Faisal Azeez on 17/12/2025.

import XCTest
import Combine
@testable import TrackingApp

class DefaultTrackingRepositoryTests: XCTestCase {
    
    func testFetchTrackingDataSuccess() async throws {
        // Given
        let mockNetworkService = MockNetworkService()
        let repository = DefaultTrackingRepository(networkService: mockNetworkService)
        
        let dto = TrackingItemDTO(
            plateNo: "X 19599",
            driverName: "John Doe",
            lat: 25.2048,
            lng: 55.2708,
            location: "Dubai, UAE",
            imageURL: "https://example.com/image.jpg",
            lastUpdated: "2024-12-14T10:30:00.000Z"
        )
        
        mockNetworkService.mockResponse = [dto]
        
        // When
        let items = try await repository.fetchTrackingData()
        
        // Then
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items[0].plateNo, "X 19599")
    }
    
    func testFetchTrackingDataError() async {
        // Given
        let mockNetworkService = MockNetworkService()
        mockNetworkService.shouldFail = true
        let repository = DefaultTrackingRepository(networkService: mockNetworkService)
        
        // When/Then
        do {
            _ = try await repository.fetchTrackingData()
            XCTFail("Expected error but got success")
        } catch {
            // Success - error was thrown
            XCTAssertTrue(true)
        }
    }
}

// MARK: - Mock Network Service
class MockNetworkService: NetworkService {
    var mockResponse: TrackingResponseDTO?
    var shouldFail = false
    
    func request<T>(url: String, headers: [String : String]) async throws -> T where T : Decodable {
        if shouldFail {
            throw NetworkError.unknown
        }
        
        if let response = mockResponse as? T {
            return response
        }
        
        throw NetworkError.decodingError
    }
}
