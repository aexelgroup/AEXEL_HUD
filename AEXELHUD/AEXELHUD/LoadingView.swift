import SwiftUI

struct LoadingView: View {
    @EnvironmentObject var navModel: NavModel
    @State private var ready = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 20) {
                Text("AEXEL HUD")
                    .font(.system(size: 36, weight: .black))
                    .foregroundStyle(.white)
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                Text("Preparing maps & sensors…")
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
        .task {
            await navModel.bootstrap()
            ready = true
        }
        .fullScreenCover(isPresented: $navModel.isReady) {
            RootTabs()
                .environmentObject(navModel)
        }
    }
}
