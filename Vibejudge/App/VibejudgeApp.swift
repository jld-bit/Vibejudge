import SwiftUI

@main
struct VibejudgeApp: App {
    @StateObject private var appViewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(appViewModel)
                .preferredColorScheme(.dark)
        }
    }
}
