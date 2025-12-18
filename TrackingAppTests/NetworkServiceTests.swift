//
//  NetworkServiceTests.swift
//  TrackingAppTests
//
//  Created by Faisal Azeez on 17/12/2025.

import XCTest
import Combine
@testable import TrackingApp

class NetworkServiceTests: XCTestCase {
    
    func testInvalidURL() async {
        let networkService = DefaultNetworkService()
        
        do {
            let _: TrackingResponseDTO = try await networkService.request(url: "", headers: [:])
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
}
