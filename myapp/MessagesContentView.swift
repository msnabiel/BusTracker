import SwiftUI
import CoreLocation
import MapKit
import FirebaseAuth
import FirebaseFirestore
struct MessagesContentView: View {
    let groupName: String
    var locationManager: LocationManager = LocationManager()
    @StateObject var messagesManager = MessagesManager()
    @State private var messageText: String = ""
    @State private var userLocations: [UserLocation] = []
    @State private var isSharingLocation: Bool = false
    var body: some View {
        VStack {
            TitleRow(title: groupName)
            
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(messagesManager.messages) { message in
                        MessageBubble(message: message)
                            .id(message.id)}}
                .padding(.top, 10)
                .background(Color("iMessageGray"))
                .cornerRadius(30, corners: [.topLeft, .topRight])
                .onChange(of: messagesManager.lastMessageId) { _, _ in
                    withAnimation {
                        proxy.scrollTo(messagesManager.lastMessageId, anchor: .bottom)
                    }
                }
            }

            MessageField(
                messageText: $messageText,
                onSend: {
                    if messageText.isEmpty {
                        if isSharingLocation {
                            stopSharingLocation()
                        } else {
                            startSharingLocation()
                        }
                    } else {
                        messagesManager.sendMessage(messageText, from: "Current User")
                        messageText = ""
                    }
                },
                onShareLocation: {
                    if isSharingLocation {
                        stopSharingLocation()
                    } else {
                        startSharingLocation()
                    }
                },
                isSharingLocation: $isSharingLocation
            )
            .environmentObject(messagesManager)
        }
        .navigationTitle("Group Chat")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchUserLocations()
        }
    }

    private func fetchUserLocations() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUserID)

        userRef.getDocument { documentSnapshot, error in
            if let error = error {
                print("Error fetching user data: \(error)")
                self.userLocations = [UserLocation(latitude: 0.0, longitude: 0.0)]
                return
            }

            guard let document = documentSnapshot, let userData = document.data() else { return }

            if let locationData = userData["location"] as? [String: Double] {
                let latitude = locationData["latitude"] ?? 0.0
                let longitude = locationData["longitude"] ?? 0.0

                let userLocation = UserLocation(latitude: latitude, longitude: longitude)
                self.userLocations = [userLocation]
            } else {
                print("User hasn't shared their location")
                self.userLocations = []
            }
        }
    }
    private func startSharingLocation() {
        locationManager.startUpdatingLocation { location in
            let userLocation = UserLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.userLocations = [userLocation]
            self.messagesManager.sendLocationMessage(location.coordinate, from: "Current User")
        }
        isSharingLocation = true
    }
    private func stopSharingLocation() {
        locationManager.stopUpdatingLocation()
        isSharingLocation = false
        messagesManager.sendMessage("User stopped sharing their live location", from: "Current User")
    }
}
class MessagesManager: ObservableObject {
  @Published var messages: [Message] = []
  @Published var lastMessageId: UUID?

  func sendMessage(_ text: String, from sender: String) {
    let newMessage = Message(text: text, sender: sender, timestamp: Date())
    messages.append(newMessage)
    lastMessageId = newMessage.id
  }

  func sendLocationMessage(_ location: CLLocationCoordinate2D, from sender: String) {
    let newMessage = Message(text: "", sender: sender, timestamp: Date(), location: location)
    messages.append(newMessage)
    lastMessageId = newMessage.id
  }

  // Add a new method to add a message with location data
  func addMessage(location: CLLocationCoordinate2D) {
    let newMessage = Message(text: "", sender: "Current User", timestamp: Date(), location: location)
    messages.append(newMessage)
    lastMessageId = newMessage.id
  }
}
struct MessagesContentView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesContentView(groupName: "Sample Group")
            .environmentObject(MessagesManager())
    }
}
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var messagesManager: MessagesManager = MessagesManager()
    private var locationManager = CLLocationManager()
    var locationUpdateHandler: ((CLLocation) -> Void)?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation(locationUpdateHandler: @escaping (CLLocation) -> Void) {
        self.locationUpdateHandler = locationUpdateHandler
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        locationUpdateHandler = nil
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationUpdateHandler?(location)
    }
}
// LocationBubble View
struct LocationBubble: View {
  let location: CLLocationCoordinate2D
  @EnvironmentObject var messagesManager: MessagesManager

  var body: some View {
    Map(coordinateRegion: .constant(MKCoordinateRegion(
      center: location,
      span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )))
    .frame(width: 200, height: 150)
    .onTapGesture {
      // Send location message and update message list
      messagesManager.sendLocationMessage(location, from: "Current User")
      messagesManager.addMessage(location: location) // Add message to list
    }
  }
}
