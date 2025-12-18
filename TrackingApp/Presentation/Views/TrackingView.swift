//
//  TrackingView.swift
//  TrackingApp
//
//  Created by Faisal Azeez on 17/12/2025.
//
import SwiftUI

struct TrackingView: View {
    @StateObject var viewModel: TrackingViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Top Navigation Bar
                CustomNavigationBar(
                    sortAscending: $viewModel.sortAscending,
                    searchText: $viewModel.searchText,
                    onSortTapped: viewModel.toggleSort
                )
                ZStack(alignment: .top) {
                    // Content
                    ZStack {
                        if viewModel.isLoading {
                            ProgressView()
                        } else if let error = viewModel.errorMessage {
                            ErrorView(message: error, onRetry: viewModel.loadData)
                        } else {
                            ZStack {
                                TrackingListView(
                                    items: viewModel.filteredItems,
                                    onItemTapped: viewModel.selectItem
                                )
                                .offset(x: viewModel.viewMode == .list ? 0 : -UIScreen.main.bounds.width)
                                .animation(.easeInOut(duration: 0.3), value: viewModel.viewMode)
                                .padding(.top,60)

                                TrackingMapView(
                                    items: viewModel.filteredItems,
                                    selectedItem: viewModel.selectedItem,
                                    onItemSelected: viewModel.selectItem
                                )
                                .offset(x: viewModel.viewMode == .map ? 0 : UIScreen.main.bounds.width)
                                .animation(.easeInOut(duration: 0.3), value: viewModel.viewMode)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    // View Mode Selector
                    ViewModeSelector(selectedMode: $viewModel.viewMode)
                        .padding(.horizontal)
                        .padding(.top, 15)
                    
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
        }
        .onAppear {
            viewModel.loadData()
        }
    }
}

struct CustomNavigationBar: View {
    @Binding var sortAscending: Bool
    @Binding var searchText: String
    @State private var isSearching = false
    let onSortTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                // Sort button
                Button(action: onSortTapped) {
                    Image("double-arrow")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text("Track Monitor")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: { withAnimation(.easeInOut(duration: 0.25)) {
                        isSearching.toggle()
                    }
                }) {
                    Image("search")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                    
                }
            }
            .padding()
            .frame(height: 60)
            .background(Color(red: 0.0, green: 0.3, blue: 0.7))
            
            // Search bar
            if isSearching {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search by plate, driver, or location", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                .padding(.vertical, 15)
                .background(Color(red: 0.0, green: 0.3, blue: 0.7))
            }
        }
    }
}

struct ViewModeSelector: View {
    @Binding var selectedMode: ViewMode
    
    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                withAnimation { selectedMode = .list }
            }) {
                Text("List")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(selectedMode == .list ? .white : Color(red: 0.0, green: 0.3, blue: 0.7))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(selectedMode == .list ? Color(red: 0.0, green: 0.3, blue: 0.7) : Color.white)
            }
            
            Button(action: {
                withAnimation { selectedMode = .map }
            }) {
                Text("Map")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(selectedMode == .map ? .white : Color(red: 0.0, green: 0.3, blue: 0.7))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(selectedMode == .map ? Color(red: 0.0, green: 0.3, blue: 0.7) : Color.white)
            }
        }
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(red: 0.0, green: 0.3, blue: 0.7), lineWidth: 1)
        )
    }
}

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("Error")
                .font(.headline)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: onRetry) {
                Text("Retry")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Color(red: 0.0, green: 0.3, blue: 0.7))
                    .cornerRadius(8)
            }
        }
    }
}
