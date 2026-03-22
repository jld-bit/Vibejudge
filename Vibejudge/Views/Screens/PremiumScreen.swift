import SwiftUI

struct PremiumScreen: View {
    @EnvironmentObject private var appViewModel: AppViewModel

    private let features = [
        PremiumFeature(icon: "sparkles", title: "Full breakdowns", description: "Unlock the complete assumptions list and richer result cards."),
        PremiumFeature(icon: "clock.arrow.trianglehead.counterclockwise.rotate.90", title: "Unlimited history", description: "Save every vibe read and revisit them later."),
        PremiumFeature(icon: "infinity", title: "Unlimited scans", description: "No free-scan cap once premium is active.")
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                CosmicBackground()

                ScrollView {
                    VStack(spacing: 20) {
                        GlowCard {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("Go Premium")
                                    .font(.largeTitle.bold())
                                Text("Keep the app playful and stylish while unlocking the full Vibejudge experience.")
                                    .foregroundStyle(.white.opacity(0.78))
                                ForEach(features) { feature in
                                    Label {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(feature.title).bold()
                                            Text(feature.description)
                                                .font(.footnote)
                                                .foregroundStyle(.white.opacity(0.72))
                                        }
                                    } icon: {
                                        Image(systemName: feature.icon)
                                            .foregroundStyle(.yellow)
                                    }
                                }
                            }
                        }

                        GlowCard {
                            VStack(alignment: .leading, spacing: 16) {
                                Text(appViewModel.premiumManager.statusMessage)
                                    .font(.subheadline)
                                Button {
                                    Task { await appViewModel.premiumManager.purchasePremium() }
                                } label: {
                                    Text(appViewModel.premiumManager.isPremiumUnlocked ? "Premium active" : "Unlock with StoreKit 2")
                                        .fontWeight(.bold)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(
                                            LinearGradient(colors: [.yellow, .orange, .pink], startPoint: .leading, endPoint: .trailing),
                                            in: RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        )
                                }
                                .disabled(appViewModel.premiumManager.isPremiumUnlocked)
                            }
                        }
                    }
                    .padding()
                }
            }
            .task {
                await appViewModel.premiumManager.loadProducts()
            }
            .navigationTitle("Premium")
        }
    }
}
