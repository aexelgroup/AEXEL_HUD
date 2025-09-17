import SwiftUI
import MapKit

struct MapScreen: View {
    @EnvironmentObject var nav: NavModel
    @State private var cameraPos = MapCameraPosition.automatic
    @State private var searchText = ""
    @State private var results: [MKMapItem] = []
    @State private var isSearching = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TextField("Search destination", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .disableAutocorrection(true)
                Button("Go") { Task { await doSearch() } }
                    .buttonStyle(.bordered)
            }
            .padding()
            
            Map(position: $cameraPos, interactionModes: .all, selection: .constant(nil)) {
                if let route = nav.route {
                    MapPolyline(route.polyline)
                        .stroke(.white, lineWidth: 6)
                }
                if let loc = nav.userLocation {
                    let ann = MKPointAnnotation()
                    ann.coordinate = loc.coordinate
                    MapUserLocationAnnotation()
                }
            }
            .mapStyle(.standard(elevation: .realistic))
            .ignoresSafeArea(edges: .bottom)
            
            List {
                ForEach(results, id: \.self) { item in
                    Button {
                        Task { await nav.buildRoute(to: item) }
                    } label: {
                        VStack(alignment: .leading) {
                            Text(item.name ?? "Result").font(.headline)
                            if let addr = item.placemark.title {
                                Text(addr).font(.footnote).foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                
                if let route = nav.route {
                    Section("Steps") {
                        ForEach(route.steps.indices, id: \.self) { i in
                            let s = route.steps[i]
                            HStack {
                                Text(s.instructions.isEmpty ? "—" : s.instructions)
                                Spacer()
                                Text(nav.formatDistance(s.distance))
                                    .foregroundStyle(.secondary)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                nav.currentStepIndex = i
                                nav.speak(s.instructions)
                            }
                        }
                    }
                }
            }
            .frame(height: 260)
        }
        .onAppear {
            if let loc = nav.userLocation {
                cameraPos = .region(MKCoordinateRegion(center: loc.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)))
            }
        }
    }
    
    func doSearch() async {
        guard !searchText.isEmpty else { return }
        isSearching = true
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        if let loc = nav.userLocation {
            request.region = MKCoordinateRegion(center: loc.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        }
        do {
            let res = try await MKLocalSearch(request: request).start()
            results = res.mapItems
        } catch {
            results = []
        }
        isSearching = false
    }
}
