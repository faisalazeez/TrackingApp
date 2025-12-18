//
//  FetchTrackingDataUseCaseTests.swift
//  TrackingAppTests
//
//  Created by Faisal Azeez on 17/12/2025.

import XCTest
import Combine
@testable import TrackingApp

class FetchTrackingDataUseCaseTests: XCTestCase {
    
    func testExecuteReturnsSortedData() async throws {
        let mockRepository = MockTrackingRepository()
        let useCase = DefaultFetchTrackingDataUseCase(repository: mockRepository)
        
        let date1 = Date()
        let date2 = Date().addingTimeInterval(-86400) // 1 day ago
        
        let items = [
            TrackingItem(id: "1", plateNo: "A", driverName: "Driver 1", location: "Loc 1",
                        latitude: 25.0, longitude: 55.0, lastUpdated: date2, driverImageURL: nil),
            TrackingItem(id: "2", plateNo: "B", driverName: "Driver 2", location: "Loc 2",
                        latitude: 25.1, longitude: 55.1, lastUpdated: date1, driverImageURL: nil)
        ]
        mockRepository.mockItems = items
        
        let result = try await useCase.execute()
        
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].id, "2") // Most recent
        XCTAssertEqual(result[1].id, "1")
    }
    
    func testExecuteHandlesError() async {
        let mockRepository = MockTrackingRepository()
        mockRepository.shouldFail = true
        let useCase = DefaultFetchTrackingDataUseCase(repository: mockRepository)
        
        do {
            _ = try await useCase.execute()
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(true)
        }
    }
}

// MARK: - Mock Repository
class MockTrackingRepository: TrackingRepository {
    var mockItems: [TrackingItem] = []
    var shouldFail = false
    
    func fetchTrackingData() async throws -> [TrackingItem] {
        if shouldFail {
            throw NSError(domain: "test", code: -1)
        }
        return mockItems
    }
}
