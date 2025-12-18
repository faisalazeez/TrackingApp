//
//  TrackingListView.swift
//  TrackingApp
//
//  Created by Faisal Azeez on 17/12/2025.
//
import SwiftUI

struct TrackingListView: View {
    let items: [TrackingItem]
    let onItemTapped: (TrackingItem) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(items) { item in
                    TrackingItemCard(item: item)
                        .onTapGesture {
                            onItemTapped(item)
                        }
                }
            }
            .padding()
        }
    }
}

struct TrackingItemCard: View {
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
