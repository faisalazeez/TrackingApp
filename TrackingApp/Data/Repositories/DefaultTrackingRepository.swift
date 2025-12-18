//
//  DefaultTrackingRepository.swift
//  TrackingApp
//
//  Created by Faisal Azeez on 17/12/2025.
//

import Foundation

class DefaultTrackingRepository: TrackingRepository {
    private let networkService: NetworkService
    private let apiURL = "https://dev.nebarex.com/file/tracking/tracking-info"
    private let apiKey = "A9fK3P2Qx7MZ8JrC5LwH6BvTnE4DYSd"
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchTrackingData() async throws -> [TrackingItem] {
        let headers = ["x-api-key": apiKey]
        
        let dtoArray: TrackingResponseDTO = try await networkService.request(
            url: apiURL,
            headers: headers
        )
        
        let items = dtoArray.toDomain()
        print("✅ Successfully mapped \(items.count) items from \(dtoArray.count) DTOs")
        return items
    }
}

