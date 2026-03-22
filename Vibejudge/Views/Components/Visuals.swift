import SwiftUI

struct CosmicBackground: View {
    var body: some View {
        LinearGradient(
            colors: [Color(red: 0.08, green: 0.06, blue: 0.20), Color(red: 0.22, green: 0.07, blue: 0.33), Color(red: 0.05, green: 0.34, blue: 0.46)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay(
            RadialGradient(colors: [.pink.opacity(0.30), .clear], center: .topLeading, startRadius: 50, endRadius: 360)
        )
        .overlay(
            RadialGradient(colors: [.cyan.opacity(0.26), .clear], center: .bottomTrailing, startRadius: 20, endRadius: 320)
        )
        .ignoresSafeArea()
    }
}

struct GlowCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(.white.opacity(0.09))
                    .background(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .fill(.ultraThinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .stroke(.white.opacity(0.18), lineWidth: 1)
                    )
                    .shadow(color: .pink.opacity(0.18), radius: 24, x: 0, y: 8)
            )
    }
}

struct TraitCardView: View {
    let trait: VibeTrait

    var body: some View {
        GlowCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(trait.title)
                        .font(.headline)
                    Spacer()
                    Text("\(trait.score)")
                        .font(.title3.weight(.bold))
                }

                ProgressView(value: Double(trait.score), total: 100)
                    .tint(Color(hex: trait.accentHex))
                    .scaleEffect(x: 1, y: 1.8, anchor: .center)

                Text(trait.summary)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.82))
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch cleaned.count {
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
