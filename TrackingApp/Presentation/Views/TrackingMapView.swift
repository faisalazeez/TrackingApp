//
//  TrackingMapView.swift
//  TrackingApp
//
//  Created by Faisal Azeez on 17/12/2025.
//
import SwiftUI
import MapKit

struct TrackingMapView: View {
    let items: [TrackingItem]
    let selectedItem: TrackingItem?
    let onItemSelected: (TrackingItem) -> Void
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 25.2048, longitude: 55.2708), // Dubai default
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Map
            Map(coordinateRegion: $region, annotationItems: items) { item in
                MapAnnotation(coordinate: item.coordinate) {
                    MapPinView(isSelected: selectedItem?.id == item.id)
                        .onTapGesture {
                            onItemSelected(item)
                            withAnimation {
                                region.center = item.coordinate
                            }
                        }
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .onAppear {
                updateRegion()
            }
            
            // Selected Item Card
            if let item = selectedItem {
                MapItemCard(item: item)
                    .padding()
                    .transition(.move(edge: .bottom))
            }
        }
    }
    
    private func updateRegion() {
        guard !items.isEmpty else { return }
        
        let coordinates = items.map { $0.coordinate }
        let minLat = coordinates.map { $0.latitude }.min() ?? 0
        let maxLat = coordinates.map { $0.latitude }.max() ?? 0
        let minLon = coordinates.map { $0.longitude }.min() ?? 0
        let maxLon = coordinates.map { $0.longitude }.max() ?? 0
        
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.5,
            longitudeDelta: (maxLon - minLon) * 1.5
        )
        
        region = MKCoordinateRegion(center: center, span: span)
    }
}

struct MapPinView: View {
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Image("location_pin")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(isSelected ? .red : .blue)
                .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                .frame(width: isSelected ? 40 : 30, height: isSelected ? 40 : 30)
        }
    }
}

struct MapItemCard: View  {
    let item: TrackingItem
    @State private var vstackHeight: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: item.driverImageURL.flatMap { URL(string: $0) }) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: vstackHeight, height: vstackHeight)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: vstackHeight, height: vstackHeight)
                        .clipped()
                case .failure:
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: vstackHeight, height: vstackHeight)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            // Item Details
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Plate No:")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(red: 0.0, green: 0.3, blue: 0.7))
                        .lineLimit(1)
                    Text(item.plateNo)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
                HStack {
                    Text("Driver Name:")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(red: 0.0, green: 0.3, blue: 0.7))
                        .lineLimit(1)
                    Text(item.driverName)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
                HStack {
                    Text("Location:")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(red: 0.0, green: 0.3, blue: 0.7))
                        .lineLimit(1)
                    Text(item.location)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
                HStack {
                    Text("Last updated:")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(red: 0.0, green: 0.3, blue: 0.7))
                        .lineLimit(1)
                    Text(item.lastUpdatedFormatted)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .background(
                GeometryReader { geo in
                    Color.clear.onAppear {
                        vstackHeight = geo.size.height
                    }
                }
            )
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
