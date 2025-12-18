//
//  TrackingItem.swift
//  TrackingApp
//
//  Created by Faisal Azeez on 17/12/2025.
//
import Foundation
import CoreLocation

struct TrackingItem: Identifiable, Equatable {
    let id: String
    let plateNo: String
    let driverName: String
    let location: String
    let latitude: Double
    let longitude: Double
    let lastUpdated: Date
    let driverImageURL: String?
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var lastUpdatedFormatted: String {
        let now = Date()
        let components = Calendar.current.dateComponents([.day], from: lastUpdated, to: now)
        
        if let days = components.day {
            if days == 0 {
                return "Today"
            } else if days == 1 {
                return "1 day ago"
            } else {
                return "\(days) days ago"
            }
        }
        return "Unknown"
    }
}
