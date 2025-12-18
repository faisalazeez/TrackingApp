//
//  TrackingViewModel.swift
//  TrackingApp
//
//  Created by Faisal Azeez on 17/12/2025.
//
import Foundation
import CoreLocation

enum ViewMode {
    case list
    case map
}

@MainActor
class TrackingViewModel: ObservableObject {
    @Published var trackingItems: [TrackingItem] = []
    @Published var filteredItems: [TrackingItem] = []
    @Published var searchText: String = "" {
        didSet {
            searchTask?.cancel()
            searchTask = Task {
                try? await Task.sleep(nanoseconds: 300_000_000) // 300ms
                if !Task.isCancelled {
                    filterItems()
                }
            }
        }
    }
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var viewMode: ViewMode = .list
    @Published var selectedItem: TrackingItem?
    @Published var sortAscending: Bool = false {
        didSet {
            applySort()
        }
    }
    
    private let fetchTrackingDataUseCase: FetchTrackingDataUseCase
    private var searchTask: Task<Void, Never>?
    
    init(fetchTrackingDataUseCase: FetchTrackingDataUseCase) {
        self.fetchTrackingDataUseCase = fetchTrackingDataUseCase
    }
    
    func loadData() {
        Task {
            isLoading = true
            errorMessage = nil
            
            do {
                let items = try await fetchTrackingDataUseCase.execute()
                self.trackingItems = items
                self.filterItems()
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
    
    func toggleSort() {
        sortAscending.toggle()
    }
    
    func selectItem(_ item: TrackingItem) {
        selectedItem = item
    }
    
    private func filterItems() {
        if searchText.isEmpty {
            filteredItems = trackingItems
        } else {
            filteredItems = trackingItems.filter { item in
                item.plateNo.localizedCaseInsensitiveContains(searchText) ||
                item.driverName.localizedCaseInsensitiveContains(searchText) ||
                item.location.localizedCaseInsensitiveContains(searchText)
            }
        }
        applySort()
    }
    
    private func applySort() {
        filteredItems.sort { item1, item2 in
            sortAscending ? item1.lastUpdated < item2.lastUpdated : item1.lastUpdated > item2.lastUpdated
        }
    }
}
