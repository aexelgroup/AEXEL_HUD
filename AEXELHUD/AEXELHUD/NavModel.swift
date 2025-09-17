import Foundation
import Combine
import MapKit
import CoreLocation
import AVFoundation

@MainActor
final class NavModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    // Settings
    @Published var mirrorMode: Bool = UserDefaults.standard.bool(forKey: "mirrorMode") {
        didSet { UserDefaults.standard.set(mirrorMode, forKey: "mirrorMode") }
    }
    @Published var useMetric: Bool = UserDefaults.standard.object(forKey: "useMetric") as? Bool ?? true {
        didSet { UserDefaults.standard.set(useMetric, forKey: "useMetric") }
    }
    @Published var voiceEnabled: Bool = UserDefaults.standard.object(forKey: "voiceEnabled") as? Bool ?? true {
        didSet { UserDefaults.standard.set(voiceEnabled, forKey: "voiceEnabled") }
    }
    @Published var voiceRate: Double = UserDefaults.standard.object(forKey: "voiceRate") as? Double ?? 0.9 {
        didSet { UserDefaults.standard.set(voiceRate, forKey: "voiceRate") }
    }
    @Published var darkHUD: Bool = true

    // Location
    private let locationMgr = CLLocationManager()
    @Published var userLocation: CLLocation?
    @Published var speedKph: Double = 0
    
    // Routing
    @Published var route: MKRoute?
    @Published var steps: [MKRoute.Step] = []
    @Published var currentStepIndex: Int = 0
    
    // TTS
    private let tts = AVSpeechSynthesizer()
    
    // App state
    @Published var isReady: Bool = false
    
    func bootstrap() async {
        locationMgr.delegate = self
        locationMgr.desiredAccuracy = kCLLocationAccuracyBest
        locationMgr.activityType = .automotiveNavigation
        locationMgr.requestWhenInUseAuthorization()
        locationMgr.startUpdatingLocation()
        locationMgr.startUpdatingHeading()
        // Small delay to feel like a loading screen
        try? await Task.sleep(nanoseconds: 800_000_000)
        isReady = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        userLocation = loc
        speedKph = max(0, loc.speed * 3.6) // m/s to km/h
    }
    
    func buildRoute(to destination: MKMapItem) async {
        guard let current = userLocation else { return }
        let src = MKMapItem(placemark: MKPlacemark(coordinate: current.coordinate))
        let req = MKDirections.Request()
        req.source = src
        req.destination = destination
        req.transportType = .automobile
        req.requestsAlternateRoutes = false
        do {
            let result = try await MKDirections(request: req).calculate()
            if let r = result.routes.first {
                route = r
                steps = r.steps.filter { !$0.instructions.isEmpty }
                currentStepIndex = 0
                speak("Route ready. \(steps.count) steps.")
            }
        } catch {
            speak("Failed to get directions.")
        }
    }
    
    func speak(_ text: String) {
        guard voiceEnabled else { return }
        let u = AVSpeechUtterance(string: text)
        u.voice = AVSpeechSynthesisVoice(language: "en-AU")
        u.rate = AVSpeechUtteranceDefaultSpeechRate * voiceRate
        tts.speak(u)
    }
    
    func stepDelta(to step: MKRoute.Step) -> CLLocationDistance {
        step.distance
    }
    
    func formatDistance(_ meters: CLLocationDistance) -> String {
        if useMetric {
            if meters < 950 { return "\(Int(meters.rounded())) m" }
            return String(format: "%.1f km", meters/1000)
        } else {
            let feet = meters * 3.28084
            if feet < 3000 { return "\(Int(feet.rounded())) ft" }
            return String(format: "%.1f mi", feet/5280)
        }
    }
}
