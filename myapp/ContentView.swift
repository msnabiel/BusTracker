import SwiftUI
struct ContentView: View {
    @State private var searchText: String = ""
    let busRoutes = [
        BusRoute(name: "Route 1", routeNumber: "R001", busPlateNumber: "ABC123"),
        BusRoute(name: "Route 2", routeNumber: "R002", busPlateNumber: "DEF456"),
        BusRoute(name: "Route 3", routeNumber: "R003", busPlateNumber: "GHI789"),
        BusRoute(name: "Route 4", routeNumber: "R004", busPlateNumber: "JKL012"),
        BusRoute(name: "Route 5", routeNumber: "R005", busPlateNumber: "MNO345"),
        BusRoute(name: "Route 6", routeNumber: "R006", busPlateNumber: "PQR678"),
        BusRoute(name: "Route 7", routeNumber: "R007", busPlateNumber: "STU901"),
        BusRoute(name: "Route 8", routeNumber: "R008", busPlateNumber: "VWX234"),
        BusRoute(name: "Route 9", routeNumber: "R009", busPlateNumber: "YZA567"),
        BusRoute(name: "Route 10", routeNumber: "R010", busPlateNumber: "BCD890"),
        BusRoute(name: "Route 11", routeNumber: "R011", busPlateNumber: "EFG123"),
        BusRoute(name: "Route 12", routeNumber: "R012", busPlateNumber: "HIJ456"),
        BusRoute(name: "Route 13", routeNumber: "R013", busPlateNumber: "KLM789"),
        BusRoute(name: "Route 14", routeNumber: "R014", busPlateNumber: "NOP012"),
        BusRoute(name: "Route 15", routeNumber: "R015", busPlateNumber: "QRS345"),
        BusRoute(name: "Route 16", routeNumber: "R016", busPlateNumber: "TUV678"),
        BusRoute(name: "Route 17", routeNumber: "R017", busPlateNumber: "WXY901"),
        BusRoute(name: "Route 18", routeNumber: "R018", busPlateNumber: "ZAB234"),
        BusRoute(name: "Route 19", routeNumber: "R019", busPlateNumber: "CDE567"),
        BusRoute(name: "Route 20", routeNumber: "R020", busPlateNumber: "FGH890"),
        BusRoute(name: "Route 21", routeNumber: "R021", busPlateNumber: "IJK123"),
        BusRoute(name: "Route 22", routeNumber: "R022", busPlateNumber: "LMN456"),
        BusRoute(name: "Route 23", routeNumber: "R023", busPlateNumber: "OPQ789"),
        BusRoute(name: "Route 24", routeNumber: "R024", busPlateNumber: "RST012"),
        BusRoute(name: "Route 25", routeNumber: "R025", busPlateNumber: "TUV345"),
        BusRoute(name: "Route 26", routeNumber: "R026", busPlateNumber: "WXY678"),
        BusRoute(name: "Route 27", routeNumber: "R027", busPlateNumber: "ZAB901"),
        BusRoute(name: "Route 28", routeNumber: "R028", busPlateNumber: "CDE234"),
        BusRoute(name: "Route 29", routeNumber: "R029", busPlateNumber: "FGH567"),
        BusRoute(name: "Route 30", routeNumber: "R030", busPlateNumber: "IJK890"),
        BusRoute(name: "Route 31", routeNumber: "R031", busPlateNumber: "LMN123"),
        BusRoute(name: "Route 32", routeNumber: "R032", busPlateNumber: "OPQ456"),
        BusRoute(name: "Route 33", routeNumber: "R033", busPlateNumber: "RST789"),
        BusRoute(name: "Route 34", routeNumber: "R034", busPlateNumber: "TUV012"),
        BusRoute(name: "Route 35", routeNumber: "R035", busPlateNumber: "WXY345"),
        BusRoute(name: "Route 36", routeNumber: "R036", busPlateNumber: "ZAB678"),
        BusRoute(name: "Route 37", routeNumber: "R037", busPlateNumber: "CDE901"),
        BusRoute(name: "Route 38", routeNumber: "R038", busPlateNumber: "FGH234"),
        BusRoute(name: "Route 39", routeNumber: "R039", busPlateNumber: "IJK567"),
        BusRoute(name: "Route 40", routeNumber: "R040", busPlateNumber: "LMN890"),
        BusRoute(name: "Route 41", routeNumber: "R041", busPlateNumber: "OPQ123"),
        BusRoute(name: "Route 42", routeNumber: "R042", busPlateNumber: "RST456"),
        BusRoute(name: "Route 43", routeNumber: "R043", busPlateNumber: "TUV789"),
        BusRoute(name: "Route 44", routeNumber: "R044", busPlateNumber: "WXY012"),
        BusRoute(name: "Route 45", routeNumber: "R045", busPlateNumber: "ZAB345")
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 255/255, green: 255/255, blue: 255/255, opacity: 1)
                    .ignoresSafeArea(.all)
                
                VStack {
                    // Search bar
                    SearchBar(text: $searchText)
                        .padding(.top, 10)
                        .padding(.horizontal, 20)
                    ScrollView {
                        VStack(spacing: 10) { // Add a spacing between bus routes
                            ForEach(busRoutes) { route in
                    NavigationLink(destination: BusRouteDetailView(busRoute: route)) {
                BusRouteView(busRoute: route)}
                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                        .padding(.vertical,5)
                        
                    }
                    .padding(.top, 10)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct BusRoute: Identifiable, Decodable{
    let id = UUID()
    let name: String
    let routeNumber: String
    let busPlateNumber: String
    //let driverName: String
    //let driverPhoneNumber: String
}

struct BusRouteView: View {
    let busRoute: BusRoute
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(busRoute.name)
                    .font(.headline)
                Text("Route: \(busRoute.routeNumber)")
                    .font(.subheadline)
                Text("Bus Plate: \(busRoute.busPlateNumber)")
                    .font(.subheadline)
            }
            .padding(20)
            Spacer()
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray, radius: 1, x: 0, y: 0)
        .padding(.horizontal, 10) // Add horizontal padding to each bus route view
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Search bar
struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(10)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                    }
                )
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 10)
        
    }
        
}

