//
//  FetchTrackingDataUseCase.swift
//  TrackingApp
//
//  Created by Faisal Azeez on 17/12/2025.
//

import Foundation

protocol FetchTrackingDataUseCase {
    func execute() async throws -> [TrackingItem]
}

class DefaultFetchTrackingDataUseCase: FetchTrackingDataUseCase {
    private let repository: TrackingRepository
    
    init(repository: TrackingRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> [TrackingItem] {
        let items = try await repository.fetchTrackingData()
        return items.sorted { $0.lastUpdated > $1.lastUpdated }
    }
}
