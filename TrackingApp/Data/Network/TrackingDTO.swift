//
//  TrackingDTO.swift
//  TrackingApp
//
//  Created by Faisal Azeez on 17/12/2025.
//
import Foundation

typealias TrackingResponseDTO = [TrackingItemDTO]

struct TrackingItemDTO: Codable {
    let plateNo: String
    let driverName: String
    let lat: Double
    let lng: Double
    let location: String
    let imageURL: String
    let lastUpdated: String
}

extension TrackingItemDTO {
    func toDomain() -> TrackingItem? {
        let date = parseDate(lastUpdated)
        guard let parsedDate = date else {
            return nil
        }
        
        let id = plateNo.replacingOccurrences(of: " ", with: "_")
        
        return TrackingItem(
            id: id,
            plateNo: plateNo,
            driverName: driverName,
            location: location,
            latitude: lat,
            longitude: lng,
            lastUpdated: parsedDate,
            driverImageURL: imageURL
        )
    }
    
    private func parseDate(_ dateString: String) -> Date? {
        let formatter1 = ISO8601DateFormatter()
        formatter1.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter1.date(from: dateString) {
            return date
        }
        
        let formatter2 = ISO8601DateFormatter()
        formatter2.formatOptions = [.withInternetDateTime]
        if let date = formatter2.date(from: dateString) {
            return date
        }
        
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = formatter3.date(from: dateString) {
            return date
        }
        
        let formatter4 = DateFormatter()
        formatter4.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = formatter4.date(from: dateString) {
            return date
        }
        
        return nil
    }
}

extension Array where Element == TrackingItemDTO {
    func toDomain() -> [TrackingItem] {
        return self.compactMap { $0.toDomain() }
    }
}
