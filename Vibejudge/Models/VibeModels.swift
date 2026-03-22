import Foundation

struct VibeTrait: Identifiable, Hashable, Codable {
    let id: UUID
    let title: String
    let score: Int
    let summary: String
    let accentHex: String

    init(id: UUID = UUID(), title: String, score: Int, summary: String, accentHex: String) {
        self.id = id
        self.title = title
        self.score = score
        self.summary = summary
        self.accentHex = accentHex
    }
}

struct AssumptionItem: Identifiable, Hashable, Codable {
    let id: UUID
    let title: String
    let description: String

    init(id: UUID = UUID(), title: String, description: String) {
        self.id = id
        self.title = title
        self.description = description
    }
}

struct VibeResult: Identifiable, Hashable, Codable {
    let id: UUID
    let createdAt: Date
    let headline: String
    let disclaimer: String
    let traits: [VibeTrait]
    let assumptions: [AssumptionItem]
    let imageData: Data?
    let isPremiumLocked: Bool

    init(
        id: UUID = UUID(),
        createdAt: Date = .now,
        headline: String,
        disclaimer: String,
        traits: [VibeTrait],
        assumptions: [AssumptionItem],
        imageData: Data?,
        isPremiumLocked: Bool
    ) {
        self.id = id
        self.createdAt = createdAt
        self.headline = headline
        self.disclaimer = disclaimer
        self.traits = traits
        self.assumptions = assumptions
        self.imageData = imageData
        self.isPremiumLocked = isPremiumLocked
    }
}

struct PremiumFeature: Identifiable, Hashable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}
