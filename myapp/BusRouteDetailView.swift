import SwiftUI
import Firebase
import FirebaseRemoteConfig

struct UserLocation: Identifiable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
}

// Views
struct BusRouteDetailView: View {
    let busRoute: BusRoute
    @StateObject var userLocationManager = UserLocationManager()
    @State private var busRoutes: [BusRoute] = []

    var body: some View {
        VStack {
            MapView(userLocations: userLocationManager.userLocations)
                .frame(height: 480)
                .cornerRadius(10)
                .padding(.horizontal, 10)
                .padding(.top, 15)
            
            ScrollView {
                VStack(spacing: 20) { // Add spacing between bus routes
                    BusRouteView(busRoute: busRoute)
                        .frame(width: UIScreen.main.bounds.width)
                        .buttonStyle(PlainButtonStyle())
                        .frame(width: UIScreen.main.bounds.width)
                        .padding(.top, 10)
                        
                    GroupChatButton(groupName: busRoute.name, numberOfMembers: 15)
                        .frame(width: UIScreen.main.bounds.width)
                        .padding(.horizontal)
                        .padding(.bottom, 3)
                        .padding(.top, 1)
                    
                    Button("Refresh") {
                        fetchBusRoutes()
                        fetchUserLocations()
                    }
                }
                .onAppear {
                    fetchBusRoutes()
                    fetchUserLocations()
                }
                .frame(maxWidth: .infinity)
                .navigationBarTitle("Bus Details", displayMode: .inline)
            }
        }
    }

    func fetchBusRoutes() {
        RemoteConfig.remoteConfig().fetchAndActivate { (status, error) in
            if let error = error {
                print("Error fetching remote config: \(error)")
                return
            }
            guard let fetchedDataString = RemoteConfig.remoteConfig()["busRoutes"].stringValue else {
                print("Failed to retrieve bus routes data from Remote Config")
                return
            }
            do {
                let jsonData = fetchedDataString.data(using: .utf8)!
                busRoutes = try JSONDecoder().decode([BusRoute].self, from: jsonData)
            } catch {
                print("Error decoding fetched bus routes: \(error)")
            }
        }
    }

    func fetchUserLocations() {
        userLocationManager.fetchUserLocations(for: busRoute) { locations in
            self.userLocationManager.userLocations = locations
        }
    }
}

struct BusRouteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BusRouteDetailView(busRoute: BusRoute(name: "Route 1", routeNumber: "R001", busPlateNumber: "ABC123"))
    }
}

struct GroupChatButton: View {
    let groupName: String
    let numberOfMembers: Int
    
    var body: some View {
        NavigationLink(destination: MessagesContentView(groupName: groupName)) {
            VStack {
                Text("\(groupName) GC")
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                Text("Number of Members: \(numberOfMembers)")
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
            }
            .padding(10)
            .background(Color.black)
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 7)
        .padding(.vertical, -10)
    }
}

