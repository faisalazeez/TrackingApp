//
//  TrackingAppApp.swift
//  TrackingApp
//
//  Created by Faisal Azeez on 17/12/2025.
//

import SwiftUI

@main
struct TrackingAppApp: App {
    var body: some Scene {
        WindowGroup {
            TrackingView(viewModel: DIContainer.shared.makeTrackingViewModel())
        }
    }
}
