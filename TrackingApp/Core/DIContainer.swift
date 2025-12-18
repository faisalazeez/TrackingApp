//
//  DIContainer.swift
//  TrackingApp
//
//  Created by Faisal Azeez on 17/12/2025.
//

import Foundation

class DIContainer {
    static let shared = DIContainer()
    
    private init() {}
    
    // MARK: - Network Layer
    lazy var networkService: NetworkService = {
        DefaultNetworkService()
    }()
    
    // MARK: - Repository Layer
    lazy var trackingRepository: TrackingRepository = {
        DefaultTrackingRepository(networkService: networkService)
    }()
    
    // MARK: - Use Cases
    lazy var fetchTrackingDataUseCase: FetchTrackingDataUseCase = {
        DefaultFetchTrackingDataUseCase(repository: trackingRepository)
    }()
    
    // MARK: - ViewModels
    @MainActor
    func makeTrackingViewModel() -> TrackingViewModel {
        TrackingViewModel(fetchTrackingDataUseCase: fetchTrackingDataUseCase)
    }
}
