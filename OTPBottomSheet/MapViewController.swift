//
//  MapViewController.swift
//  OTPBottomSheet
//
//  Created by Manu on 2025-09-17.
//

import UIKit
import MapKit
import SwiftUI

class MapViewController: UIViewController {
    private let mapView = MKMapView()
    private let bottomSheet = CustomBottomSheet()
    private var locations: [PlaceLocation] = []
    private var selectedLocation: PlaceLocation?
    private var isShowingCompactView = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupNavigationBar()
        setupBottomSheet()
        loadSampleData()
        addAnnotations()
    }

    private func setupBottomSheet() {
        bottomSheet.delegate = self
    }

    private func setupMapView() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none

        // Make map truly full screen - ignore all safe areas
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Set initial region (San Francisco Bay Area)
        let initialLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        let region = MKCoordinateRegion(center: initialLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: false)
    }

    private func setupNavigationBar() {
        // Hide navigation bar completely for full screen map
        navigationController?.setNavigationBarHidden(true, animated: false)

        // Add floating buttons on top of the map
        setupFloatingButtons()
    }

    private func setupFloatingButtons() {
        // Search button
        let searchButton = UIButton(type: .system)
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.9)
        searchButton.layer.cornerRadius = 22
        searchButton.layer.shadowColor = UIColor.black.cgColor
        searchButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        searchButton.layer.shadowRadius = 4
        searchButton.layer.shadowOpacity = 0.1
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)

        // List button
        let listButton = UIButton(type: .system)
        listButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        listButton.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.9)
        listButton.layer.cornerRadius = 22
        listButton.layer.shadowColor = UIColor.black.cgColor
        listButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        listButton.layer.shadowRadius = 4
        listButton.layer.shadowOpacity = 0.1
        listButton.translatesAutoresizingMaskIntoConstraints = false
        listButton.addTarget(self, action: #selector(showListView), for: .touchUpInside)

        view.addSubview(searchButton)
        view.addSubview(listButton)

        NSLayoutConstraint.activate([
            // Search button - top right
            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchButton.widthAnchor.constraint(equalToConstant: 44),
            searchButton.heightAnchor.constraint(equalToConstant: 44),

            // List button - below search button
            listButton.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 12),
            listButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            listButton.widthAnchor.constraint(equalToConstant: 44),
            listButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func loadSampleData() {
        locations = [
            PlaceLocation(
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
            ),
            PlaceLocation(
                name: "Fisherman's Wharf",
                category: "Tourist Attraction",
                address: "Fisherman's Wharf, San Francisco, CA",
                rating: 4.2,
                reviewCount: 23456,
                coordinate: CLLocationCoordinate2D(latitude: 37.8085, longitude: -122.4108),
                description: "Historic waterfront area with shops, restaurants, and sea lions.",
                imageURL: "https://example.com/fishermans-wharf.jpg",
                isOpen: true,
                openingHours: "6:00 AM - 10:00 PM",
                phoneNumber: "(415) 674-7503"
            ),
            PlaceLocation(
                name: "Alcatraz Island",
                category: "Historic Site",
                address: "Alcatraz Island, San Francisco, CA",
                rating: 4.6,
                reviewCount: 18765,
                coordinate: CLLocationCoordinate2D(latitude: 37.8267, longitude: -122.4230),
                description: "Former federal prison on an island in San Francisco Bay.",
                imageURL: "https://example.com/alcatraz.jpg",
                isOpen: true,
                openingHours: "9:00 AM - 6:30 PM",
                phoneNumber: "(415) 561-4900"
            ),
            PlaceLocation(
                name: "Lombard Street",
                category: "Street",
                address: "Lombard Street, San Francisco, CA",
                rating: 4.3,
                reviewCount: 12987,
                coordinate: CLLocationCoordinate2D(latitude: 37.8022, longitude: -122.4187),
                description: "Famous winding street known as the 'crookedest street in the world'.",
                imageURL: "https://example.com/lombard-street.jpg",
                isOpen: true,
                openingHours: "Always accessible",
                phoneNumber: nil
            ),
            PlaceLocation(
                name: "Chinatown",
                category: "Neighborhood",
                address: "Chinatown, San Francisco, CA",
                rating: 4.4,
                reviewCount: 8765,
                coordinate: CLLocationCoordinate2D(latitude: 37.7941, longitude: -122.4078),
                description: "Vibrant neighborhood with authentic Chinese culture, food, and shops.",
                imageURL: "https://example.com/chinatown.jpg",
                isOpen: true,
                openingHours: "Varies by business",
                phoneNumber: nil
            )
        ]
    }

    private func addAnnotations() {
        let annotations = locations.map { location in
            PlaceAnnotation(location: location)
        }
        mapView.addAnnotations(annotations)
    }

    @objc private func searchButtonTapped() {
        // Show search functionality in bottom sheet
        let searchView = SearchView { [weak self] query in
            self?.performSearch(query: query)
        }

        let config = BottomSheetConfiguration(
            initialPosition: .half,
            supportedPositions: [.half, .full]
        )

        bottomSheet.present(content: searchView, on: self, configuration: config)
    }

    @objc private func showListView() {
        let listView = PlaceListView(locations: locations) { [weak self] location in
            // Just zoom to location and move sheet to tip position
            self?.selectedLocation = location
            self?.zoomToLocationFromList(location)
            self?.bottomSheet.moveToPosition(.tip, animated: true)
        }

        bottomSheet.present(content: listView, on: self)
    }

    private func performSearch(query: String) {
        // Simple search implementation
        let filteredLocations = locations.filter { location in
            location.name.localizedCaseInsensitiveContains(query) ||
            location.category.localizedCaseInsensitiveContains(query)
        }

        if let firstResult = filteredLocations.first {
            zoomToLocation(firstResult)
            showLocationDetails(firstResult)
        }
    }

    // MARK: - Location Display Methods

    private func showLocationInCompactMode(_ location: PlaceLocation) {
        selectedLocation = location
        isShowingCompactView = true

        let compactView = CompactPlaceView(
            location: location,
            directionsAction: { [weak self] in
                self?.openDirections(to: location)
            },
            callAction: { [weak self] in
                self?.callLocation(location)
            },
            shareAction: { [weak self] in
                self?.shareLocation(location)
            },
            expandAction: { [weak self] in
                self?.expandToDetailView()
            }
        )

        let config = BottomSheetConfiguration(
            initialPosition: .tip,
            supportedPositions: [.tip, .half, .full]
        )

        // Check if we're already showing the list view in the sheet
        let currentPosition = bottomSheet.getCurrentPosition()

        // Always update to compact view and move to tip position
        bottomSheet.updateContent(compactView, animated: true)
        bottomSheet.moveToPosition(.tip, animated: true)

        // Zoom to location with slight delay to coordinate with sheet animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.zoomToLocation(location)
        }
    }

    private func expandToDetailView() {
        guard let location = selectedLocation else { return }
        isShowingCompactView = false

        let detailView = PlaceDetailView(location: location) { [weak self] in
            self?.openDirections(to: location)
        } callAction: { [weak self] in
            self?.callLocation(location)
        } shareAction: { [weak self] in
            self?.shareLocation(location)
        }

        bottomSheet.updateContent(detailView, animated: true)
        bottomSheet.moveToPosition(.half, animated: true)
    }

    private func showLocationDetails(_ location: PlaceLocation) {
        selectedLocation = location
        isShowingCompactView = false

        let detailView = PlaceDetailView(location: location) { [weak self] in
            self?.openDirections(to: location)
        } callAction: { [weak self] in
            self?.callLocation(location)
        } shareAction: { [weak self] in
            self?.shareLocation(location)
        }

        let config = BottomSheetConfiguration(
            initialPosition: .half,
            supportedPositions: [.tip, .half, .full]
        )

        bottomSheet.present(content: detailView, on: self, configuration: config)
        zoomToLocation(location)
    }

    private func zoomToLocation(_ location: PlaceLocation) {
        // Different zoom levels based on sheet state
        let zoomDistance: CLLocationDistance = isShowingCompactView ? 500 : 1000

        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: zoomDistance,
            longitudinalMeters: zoomDistance
        )

        // Smooth animation
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
            self.mapView.setRegion(region, animated: false)
        }

        // Highlight the selected annotation
        highlightAnnotation(for: location)
    }

    private func zoomToLocationFromList(_ location: PlaceLocation) {
        // Zoom without selecting annotation to avoid feedback loop
        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )

        // Smooth animation without annotation selection
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
            self.mapView.setRegion(region, animated: false)
        }

        // Just deselect any currently selected annotations to clean up
        mapView.selectedAnnotations.forEach { annotation in
            mapView.deselectAnnotation(annotation, animated: false)
        }
    }

    private func highlightAnnotation(for location: PlaceLocation) {
        // First deselect all annotations
        mapView.selectedAnnotations.forEach { annotation in
            mapView.deselectAnnotation(annotation, animated: false)
        }

        // Find and select the target annotation
        if let annotation = mapView.annotations.first(where: { annotation in
            if let placeAnnotation = annotation as? PlaceAnnotation {
                return placeAnnotation.location.id == location.id
            }
            return false
        }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.mapView.selectAnnotation(annotation, animated: true)
            }
        }
    }

    private func openDirections(to location: PlaceLocation) {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate))
        mapItem.name = location.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }

    private func callLocation(_ location: PlaceLocation) {
        guard let phoneNumber = location.phoneNumber,
              let url = URL(string: "tel:\(phoneNumber.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: ""))") else {
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    private func shareLocation(_ location: PlaceLocation) {
        let activityViewController = UIActivityViewController(
            activityItems: [location.name, location.address],
            applicationActivities: nil
        )

        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        present(activityViewController, animated: true)
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let placeAnnotation = annotation as? PlaceAnnotation else {
            return nil
        }

        let identifier = "PlaceAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = false
            annotationView?.animatesWhenAdded = true
        } else {
            annotationView?.annotation = annotation
        }

        // Customize marker based on category
        switch placeAnnotation.location.category {
        case "Landmark":
            annotationView?.markerTintColor = .systemRed
            annotationView?.glyphText = "🏛️"
        case "Tourist Attraction":
            annotationView?.markerTintColor = .systemBlue
            annotationView?.glyphText = "📍"
        case "Historic Site":
            annotationView?.markerTintColor = .systemBrown
            annotationView?.glyphText = "🏰"
        case "Street":
            annotationView?.markerTintColor = .systemGray
            annotationView?.glyphText = "🛣️"
        case "Neighborhood":
            annotationView?.markerTintColor = .systemGreen
            annotationView?.glyphText = "🏘️"
        default:
            annotationView?.markerTintColor = .systemPurple
            annotationView?.glyphText = "📌"
        }

        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let placeAnnotation = view.annotation as? PlaceAnnotation else {
            return
        }

        // Only show details if we're not already showing the list view in tip position
        // This prevents feedback loop when zooming from list
        if bottomSheet.getCurrentPosition() == .tip {
            // If we're in tip position (likely from list selection), don't trigger detail view
            return
        }

        showLocationDetails(placeAnnotation.location)
    }
}

// MARK: - BottomSheetDelegate
extension MapViewController: BottomSheetDelegate {
    func bottomSheetDidChangePosition(_ position: BottomSheetPosition) {
        // Simple position tracking
        switch position {
        case .tip:
            isShowingCompactView = true
        case .half, .full:
            isShowingCompactView = false
        }
    }
}