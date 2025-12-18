//
//  TrackingRepository.swift
//  TrackingApp
//
//  Created by Faisal Azeez on 17/12/2025.
//


import Foundation

protocol TrackingRepository {
    func fetchTrackingData() async throws -> [TrackingItem]
}

