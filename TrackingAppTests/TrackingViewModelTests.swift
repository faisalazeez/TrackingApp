//
//  TrackingViewModelTests.swift
//  TrackingAppTests
//
//  Created by Faisal Azeez on 17/12/2025.

import XCTest
import Combine
@testable import TrackingApp

@MainActor
class TrackingViewModelTests: XCTestCase {
    
    func testLoadDataSuccess() async {
        let mockUseCase = MockFetchTrackingDataUseCase()
        let viewModel = TrackingViewModel(fetchTrackingDataUseCase: mockUseCase)
        
        let items = [
            createMockItem(id: "1", plateNo: "A"),
            createMockItem(id: "2", plateNo: "B")
        ]
        mockUseCase.mockItems = items
        
        viewModel.loadData()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.trackingItems.count, 2)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testSearchFiltering() async {
        let mockUseCase = MockFetchTrackingDataUseCase()
        let viewModel = TrackingViewModel(fetchTrackingDataUseCase: mockUseCase)
        
        let items = [
            createMockItem(id: "1", plateNo: "X 19599"),
            createMockItem(id: "2", plateNo: "Y 12345")
        ]
        mockUseCase.mockItems = items
        
        viewModel.loadData()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        viewModel.searchText = "19599"
        try? await Task.sleep(nanoseconds: 400_000_000)
        
        XCTAssertEqual(viewModel.filteredItems.count, 1)
        XCTAssertEqual(viewModel.filteredItems[0].plateNo, "X 19599")
    }
    
    func testToggleSort() async {
        let mockUseCase = MockFetchTrackingDataUseCase()
        let viewModel = TrackingViewModel(fetchTrackingDataUseCase: mockUseCase)
        
        let items = [
            createMockItem(id: "1", daysAgo: 1),
            createMockItem(id: "2", daysAgo: 0)
        ]
        mockUseCase.mockItems = items
        
        viewModel.loadData()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(viewModel.filteredItems[0].id, "2")
        
        viewModel.toggleSort()
        
        XCTAssertTrue(viewModel.sortAscending)
        XCTAssertEqual(viewModel.filteredItems[0].id, "1")
    }
    
    // MARK: - Helper Methods
    private func createMockItem(
        id: String,
        plateNo: String = "X 19599",
        daysAgo: Int = 0
    ) -> TrackingItem {
        let date = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date())!
        return TrackingItem(
            id: id,
            plateNo: plateNo,
            driverName: "John Doe",
            location: "Dubai, UAE",
            latitude: 25.2048,
            longitude: 55.2708,
            lastUpdated: date,
            driverImageURL: nil
        )
    }
}

// MARK: - Mock Use Case
class MockFetchTrackingDataUseCase: FetchTrackingDataUseCase {
    var mockItems: [TrackingItem] = []
    var shouldFail = false
    
    func execute() async throws -> [TrackingItem] {
        if shouldFail {
            throw NSError(domain: "test", code: -1)
        }
        return mockItems
    }
}
