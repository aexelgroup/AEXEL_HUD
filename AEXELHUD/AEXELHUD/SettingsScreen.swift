import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject var nav: NavModel
    var body: some View {
        NavigationView {
            Form {
                Section("HUD") {
                    Toggle("Mirror Mode", isOn: $nav.mirrorMode)
                    Toggle("Dark HUD", isOn: $nav.darkHUD)
                    Picker("Units", selection: $nav.useMetric) {
                        Text("Metric (km/h)").tag(true)
                        Text("Imperial (mph)").tag(false)
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Voice Guidance") {
                    Toggle("Enabled", isOn: $nav.voiceEnabled)
                    HStack {
                        Text("Rate")
                        Slider(value: $nav.voiceRate, in: 0.5...1.2, step: 0.05)
                        Text(String(format: "%.2f", nav.voiceRate))
                            .frame(width: 48, alignment: .trailing)
                    }
                }
                
                Section("About") {
                    NavigationLink("Legal & About") { AboutLegalView() }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
