import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            UploadScreen()
                .tabItem {
                    Label("Scan", systemImage: "sparkles.rectangle.stack")
                }

            SavedScreen()
                .tabItem {
                    Label("Saved", systemImage: "bookmark.fill")
                }

            PremiumScreen()
                .tabItem {
                    Label("Premium", systemImage: "crown.fill")
                }
        }
    }
}
