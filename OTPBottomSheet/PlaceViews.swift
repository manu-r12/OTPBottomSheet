//
//  PlaceViews.swift
//  OTPBottomSheet
//
//  Created by Manu on 2025-09-17.
//

import SwiftUI
import MapKit

// MARK: - Compact Place View
struct CompactPlaceView: View {
    let location: PlaceLocation
    let directionsAction: () -> Void
    let callAction: () -> Void
    let shareAction: () -> Void
    let expandAction: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Drag indicator
            RoundedRectangle(cornerRadius: 2)
                .fill(Color(.systemGray4))
                .frame(width: 36, height: 4)
                .padding(.top, 8)
                .padding(.bottom, 12)

            // Compact content
            HStack(spacing: 12) {
                // Location info
                VStack(alignment: .leading, spacing: 4) {
                    Text(location.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(1)

                    Text(location.category)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    HStack(spacing: 8) {
                        // Rating
                        HStack(spacing: 2) {
                            ForEach(0..<5) { index in
                                Image(systemName: index < Int(location.rating) ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .font(.caption2)
                            }
                        }

                        Text("\(location.rating, specifier: "%.1f")")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        // Status
                        HStack {
                            Circle()
                                .fill(location.isOpen ? Color.green : Color.red)
                                .frame(width: 6, height: 6)

                            Text(location.isOpen ? "Open" : "Closed")
                                .font(.caption2)
                                .foregroundColor(location.isOpen ? .green : .red)
                        }
                    }
                }

                Spacer()

                // Expand button
                Button(action: expandAction) {
                    Image(systemName: "chevron.up")
                        .font(.title3)
                        .foregroundColor(.blue)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)

            // Quick actions
            HStack(spacing: 32) {
                CompactActionButton(
                    icon: "location.circle.fill",
                    title: "Directions",
                    color: .blue,
                    action: directionsAction
                )

                if location.phoneNumber != nil {
                    CompactActionButton(
                        icon: "phone.circle.fill",
                        title: "Call",
                        color: .green,
                        action: callAction
                    )
                }

                CompactActionButton(
                    icon: "square.and.arrow.up.circle.fill",
                    title: "Share",
                    color: .gray,
                    action: shareAction
                )

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .onTapGesture {
            expandAction()
        }
    }
}

struct CompactActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)

                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
        }
    }
}

struct PlaceDetailView: View {
    let location: PlaceLocation
    let directionsAction: () -> Void
    let callAction: () -> Void
    let shareAction: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header with image placeholder and basic info
                VStack(alignment: .leading, spacing: 12) {
                    // Image placeholder
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                        )

                    // Title and category
                    VStack(alignment: .leading, spacing: 4) {
                        Text(location.name)
                            .font(.title2)
                            .fontWeight(.bold)

                        Text(location.category)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    // Rating and status
                    HStack {
                        HStack(spacing: 2) {
                            ForEach(0..<5) { index in
                                Image(systemName: index < Int(location.rating) ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .font(.caption)
                            }
                        }

                        Text("\(location.rating, specifier: "%.1f")")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text("(\(location.reviewCount) reviews)")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Spacer()

                        HStack {
                            Circle()
                                .fill(location.isOpen ? Color.green : Color.red)
                                .frame(width: 8, height: 8)

                            Text(location.isOpen ? "Open" : "Closed")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(location.isOpen ? .green : .red)
                        }
                    }
                }

                Divider()

                // Action buttons
                HStack(spacing: 16) {
                    ActionButton(
                        icon: "location.circle.fill",
                        title: "Directions",
                        color: .blue,
                        action: directionsAction
                    )

                    if location.phoneNumber != nil {
                        ActionButton(
                            icon: "phone.circle.fill",
                            title: "Call",
                            color: .green,
                            action: callAction
                        )
                    }

                    ActionButton(
                        icon: "square.and.arrow.up.circle.fill",
                        title: "Share",
                        color: .gray,
                        action: shareAction
                    )

                    Spacer()
                }

                Divider()

                // Details section
                VStack(alignment: .leading, spacing: 16) {
                    DetailRow(icon: "mappin.circle.fill", title: "Address", content: location.address)

                    DetailRow(icon: "clock.circle.fill", title: "Hours", content: location.openingHours)

                    if let phoneNumber = location.phoneNumber {
                        DetailRow(icon: "phone.circle.fill", title: "Phone", content: phoneNumber)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title3)

                            Text("About")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }

                        Text(location.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                // Reviews section placeholder
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "star.circle.fill")
                            .foregroundColor(.yellow)
                            .font(.title3)

                        Text("Reviews")
                            .font(.headline)
                            .fontWeight(.semibold)

                        Spacer()

                        Button("See all") {
                            // Handle see all reviews
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }

                    // Sample reviews
                    ForEach(0..<2) { index in
                        ReviewRow(
                            username: index == 0 ? "John D." : "Sarah M.",
                            rating: index == 0 ? 5 : 4,
                            review: index == 0 ? "Amazing place! Definitely worth visiting." : "Great experience, would recommend to others.",
                            date: "2 days ago"
                        )
                    }
                }
            }
            .padding()
        }
    }
}

struct ActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)

                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
        }
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let content: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.title3)
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)

                Text(content)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
    }
}

struct ReviewRow: View {
    let username: String
    let rating: Int
    let review: String
    let date: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(username)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Spacer()

                HStack(spacing: 2) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < rating ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .font(.caption2)
                    }
                }

                Text(date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Text(review)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct PlaceListView: View {
    let locations: [PlaceLocation]
    let onLocationSelected: (PlaceLocation) -> Void

    var body: some View {
        NavigationView {
            List(locations) { location in
                PlaceListRow(location: location) {
                    onLocationSelected(location)
                }
            }
            .navigationTitle("Places")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct PlaceListRow: View {
    let location: PlaceLocation
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Category icon
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: categoryIcon(for: location.category))
                            .foregroundColor(.blue)
                            .font(.title3)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(location.name)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(location.category)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    HStack {
                        HStack(spacing: 2) {
                            ForEach(0..<5) { index in
                                Image(systemName: index < Int(location.rating) ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .font(.caption2)
                            }
                        }

                        Text("\(location.rating, specifier: "%.1f")")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Spacer()

                        HStack {
                            Circle()
                                .fill(location.isOpen ? Color.green : Color.red)
                                .frame(width: 6, height: 6)

                            Text(location.isOpen ? "Open" : "Closed")
                                .font(.caption2)
                                .foregroundColor(location.isOpen ? .green : .red)
                        }
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func categoryIcon(for category: String) -> String {
        switch category {
        case "Landmark": return "building.columns"
        case "Tourist Attraction": return "camera"
        case "Historic Site": return "building"
        case "Street": return "road.lanes"
        case "Neighborhood": return "house.fill"
        default: return "mappin"
        }
    }
}

struct SearchView: View {
    @State private var searchText = ""
    let onSearch: (String) -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Search Places")
                        .font(.title2)
                        .fontWeight(.bold)

                    TextField("Search for places, landmarks, or categories", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            if !searchText.isEmpty {
                                onSearch(searchText)
                            }
                        }

                    Button("Search") {
                        if !searchText.isEmpty {
                            onSearch(searchText)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(searchText.isEmpty)
                }

                // Quick search suggestions
                VStack(alignment: .leading, spacing: 12) {
                    Text("Quick Search")
                        .font(.headline)
                        .fontWeight(.semibold)

                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        QuickSearchButton(title: "Landmarks", icon: "building.columns") {
                            onSearch("Landmark")
                        }

                        QuickSearchButton(title: "Attractions", icon: "camera") {
                            onSearch("Tourist Attraction")
                        }

                        QuickSearchButton(title: "Historic Sites", icon: "building") {
                            onSearch("Historic Site")
                        }

                        QuickSearchButton(title: "Streets", icon: "road.lanes") {
                            onSearch("Street")
                        }
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
}

struct QuickSearchButton: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.blue)

                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let sampleLocation = PlaceLocation(
        name: "Golden Gate Bridge",
        category: "Landmark",
        address: "Golden Gate Bridge, San Francisco, CA",
        rating: 4.8,
        reviewCount: 45234,
        coordinate: CLLocationCoordinate2D(latitude: 37.8199, longitude: -122.4783),
        description: "Iconic suspension bridge spanning the Golden Gate strait.",
        imageURL: "https://example.com/golden-gate.jpg",
        isOpen: true,
        openingHours: "Always open",
        phoneNumber: "(415) 921-5858"
    )

    PlaceDetailView(
        location: sampleLocation,
        directionsAction: {},
        callAction: {},
        shareAction: {}
    )
}