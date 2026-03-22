import SwiftUI

struct SavedScreen: View {
    @EnvironmentObject private var appViewModel: AppViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                CosmicBackground()

                if appViewModel.savedResults.isEmpty {
                    ContentUnavailableView(
                        "No saved vibes yet",
                        systemImage: "bookmark.slash",
                        description: Text("Save a result from the Scan tab to build your glow-up history.")
                    )
                    .foregroundStyle(.white)
                } else {
                    List {
                        ForEach(appViewModel.savedResults) { result in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(result.headline)
                                    .font(.headline)
                                Text(result.createdAt, style: .date)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(result.traits.map(\.title).joined(separator: " • "))
                                    .font(.footnote)
                            }
                            .listRowBackground(Color.white.opacity(0.08))
                        }
                        .onDelete { offsets in
                            for index in offsets {
                                appViewModel.removeSavedResult(id: appViewModel.savedResults[index].id)
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
            }
            .navigationTitle("Saved Reads")
        }
    }
}
