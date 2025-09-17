import SwiftUI

struct RootTabs: View {
    @EnvironmentObject var nav: NavModel
    var body: some View {
        TabView {
            Mirrorable(mirrored: nav.mirrorMode) {
                HUDView()
            }
            .tabItem { Label("HUD", systemImage: "display") }
            
            MapScreen()
                .tabItem { Label("Map", systemImage: "map") }
            
            SettingsScreen()
                .tabItem { Label("Settings", systemImage: "gearshape") }
            
            AboutLegalView()
                .tabItem { Label("About", systemImage: "info.circle") }
        }
        .preferredColorScheme(.dark)
        .tint(.white)
    }
}
