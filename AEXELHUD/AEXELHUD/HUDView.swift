import SwiftUI
import MapKit

struct HUDView: View {
    @EnvironmentObject var nav: NavModel
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 24) {
                Image(systemName: symbolForCurrentStep())
                    .font(.system(size: 120, weight: .black))
                    .foregroundStyle(.white)
                Text(distanceString())
                    .font(.system(size: 72, weight: .black))
                    .foregroundStyle(.white)
                HStack(spacing: 24) {
                    Text(speedString())
                        .font(.system(size: 64, weight: .heavy))
                        .foregroundStyle(.white)
                }
            }
            .padding(32)
        }
    }
    
    func distanceString() -> String {
        guard let route = nav.route else { return "—" }
        let idx = min(nav.currentStepIndex, max(0, route.steps.count - 1))
        let d = route.steps[idx].distance
        return nav.formatDistance(d)
    }
    
    func speedString() -> String {
        if nav.useMetric { return "\(Int(nav.speedKph.rounded())) km/h" }
        let mph = nav.speedKph * 0.621371
        return "\(Int(mph.rounded())) mph"
    }
    
    func symbolForCurrentStep() -> String {
        guard let route = nav.route else { return "arrow.up" }
        let idx = min(nav.currentStepIndex, max(0, route.steps.count - 1))
        let instr = route.steps[idx].instructions.lowercased()
        if instr.contains("left") { return "arrow.turn.left" }
        if instr.contains("right") { return "arrow.turn.right" }
        if instr.contains("roundabout") { return "arrow.triangle.turn.up.right.circle" }
        return "arrow.up"
    }
}
