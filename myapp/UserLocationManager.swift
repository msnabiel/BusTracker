//import Foundation
import Combine
import CoreLocation

/*class UserLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location.coordinate
    }
}*/
import Foundation
import Firebase

class UserLocationManager: ObservableObject {
    @Published var userLocations: [UserLocation] = []

    func fetchUserLocations(for busRoute: BusRoute, completion: @escaping ([UserLocation]) -> Void) {
        // Fetch the user locations from your backend or Firebase
        // Here we are simulating fetching locations with a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let sampleLocations = [
                UserLocation(latitude: 34.052235, longitude: -118.243683), // Example location 1
                UserLocation(latitude: 34.062235, longitude: -118.253683)  // Example location 2
            ]
            completion(sampleLocations)
        }
    }
}

