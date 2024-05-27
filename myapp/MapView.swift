import SwiftUI
import MapKit

struct MapView: View {
    var userLocations: [UserLocation]

    @State private var region: MKCoordinateRegion

    init(userLocations: [UserLocation]) {
        self.userLocations = userLocations

        if let firstUserLocation = userLocations.first {
            let center = CLLocationCoordinate2D(latitude: firstUserLocation.latitude, longitude: firstUserLocation.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            _region = State(initialValue: MKCoordinateRegion(center: center, span: span))
        } else {
            // Default region if no user locations available
            let center = CLLocationCoordinate2D(latitude: 0, longitude: 0)
            let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
            _region = State(initialValue: MKCoordinateRegion(center: center, span: span))
        }
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: userLocations) { userLocation in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude)) {
                MarkerView()
            }
        }
    }
}

struct MarkerView: View {
    var body: some View {
        Image(systemName: "mappin.and.ellipse")
            .foregroundColor(.blue)
    }
}

