//
//  MessageUI.swift
//  myapp
//
//  Created by Syed Nabiel Hasaan M on 27/05/24.
//
import Foundation
import SwiftUI
import CoreLocation
import MapKit
import FirebaseAuth
import FirebaseFirestore
// MessageField View
struct MessageField: View {
    @Binding var messageText: String
    var onSend: () -> Void
    var onShareLocation: () -> Void
    @Binding var isSharingLocation: Bool

    var body: some View {
        HStack {
            TextField("Enter message...", text: $messageText)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color("black"))
                .cornerRadius(20)
                .font(.body)
                .foregroundColor(.black)
                .colorScheme(.light)
            Button(action: onSend) {
                Text("Send")
                    .foregroundColor(.white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(Color.black)
                    .cornerRadius(20)
            }
            Button(action: onShareLocation) {
                Image(systemName: isSharingLocation ? "location.fill" : "location")
                    .foregroundColor(isSharingLocation ? .green : .blue)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(20)
            }
        }
        .padding()
        .background(Color("iMessageGray"))
    }
}
// MessageBubble View
struct MessageBubble: View {
    let message: Message

    var body: some View {
        HStack {
            if message.sender == "Current User" {
                Spacer()
                if let location = message.location {
                    LocationBubble(location: location)
                        .background(Color.black)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black, lineWidth: 1)
                        )
                } else {
                    Text(message.text)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
            } else {
                if let location = message.location {
                    LocationBubble(location: location)
                        .background(Color("iMessageGray"))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                } else {
                    Text(message.text)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Color("iMessageGray"))
                        .foregroundColor(.black)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .background(Color("iMessageGray"))
    }
}

// TitleRow View
struct TitleRow: View {
    let title: String

    var body: some View {
        HStack {
            Spacer()
            Text(title)
                .font(.title2)
                .bold()
                .foregroundColor(.black)
            Spacer()
        }
        .padding()
        .background(Color.white)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
// Models
struct Message: Identifiable {
    let id = UUID()
    let text: String
    let sender: String
    let timestamp: Date
    let location: CLLocationCoordinate2D?
    
    init(text: String, sender: String, timestamp: Date, location: CLLocationCoordinate2D? = nil) {
        self.text = text
        self.sender = sender
        self.timestamp = timestamp
        self.location = location
    }
}
