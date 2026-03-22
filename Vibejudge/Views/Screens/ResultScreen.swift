import SwiftUI

struct ResultScreen: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    let result: VibeResult

    var body: some View {
        VStack(spacing: 16) {
            headlineCard

            ForEach(result.traits) { trait in
                TraitCardView(trait: trait)
            }

            assumptionsCard
            actionsCard
        }
    }

    private var headlineCard: some View {
        GlowCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("First impression")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.65))
                Text(result.headline)
                    .font(.title.bold())
                Text(result.disclaimer)
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.74))
            }
        }
    }

    private var assumptionsCard: some View {
        GlowCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("What people might assume")
                        .font(.headline)
                    if result.isPremiumLocked {
                        Spacer()
                        Label("Premium", systemImage: "lock.fill")
                            .font(.caption)
                            .padding(8)
                            .background(.yellow.opacity(0.18), in: Capsule())
                    }
                }

                ForEach(result.assumptions) { item in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .font(.subheadline.bold())
                        Text(item.description)
                            .font(.footnote)
                            .foregroundStyle(.white.opacity(0.78))
                    }
                }

                if result.isPremiumLocked {
                    Text("Free mode shows a lighter preview. Premium unlocks the full assumption list and unlimited history.")
                        .font(.footnote)
                        .foregroundStyle(.yellow.opacity(0.92))
                }
            }
        }
    }

    private var actionsCard: some View {
        GlowCard {
            HStack(spacing: 12) {
                Button("Save result") {
                    appViewModel.saveCurrentResult()
                }
                .buttonStyle(.borderedProminent)

                ShareLink(item: shareText) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
                .buttonStyle(.bordered)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var shareText: String {
        let topTrait = result.traits.max(by: { $0.score < $1.score })?.title ?? "vibe"
        return "My Vibejudge first-impression read says my strongest vibe is \(topTrait): \(result.headline)"
    }
}
