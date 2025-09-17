import SwiftUI

@main
struct AEXELHUDApp: App {
    @AppStorage("mirrorMode") private var mirrorMode: Bool = true
    @StateObject private var navModel = NavModel()
    var body: some Scene {
        WindowGroup {
            LoadingView()
                .environmentObject(navModel)
        }
    }
}
