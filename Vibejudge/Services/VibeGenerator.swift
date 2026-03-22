import Foundation

protocol VibeGenerating {
    func generateProfile(seed: Int, isPremium: Bool, faceDetected: Bool) -> VibeResult
}

struct VibeGenerator: VibeGenerating {
    private let positiveHeadlines = [
        "Main-character energy with a soft edge",
        "Warm, magnetic, and quietly iconic",
        "Polished confidence with a playful spark",
        "Chill charisma people instantly notice"
    ]

    private let traitPools: [(title: String, values: [(Int, String, String)])] = [
        ("Confidence vibe", [
            (72, "You come across as self-assured and grounded.", "#FF7AF6"),
            (84, "Your photo gives poised, fearless energy.", "#7A9CFF"),
            (91, "You radiate standout confidence without trying too hard.", "#6EF3D6")
        ]),
        ("Approachability", [
            (68, "You seem easy to talk to and naturally welcoming.", "#FFD86B"),
            (79, "People would expect good vibes and a kind first hello.", "#FF8C82"),
            (88, "Your look feels open, bright, and instantly friendly.", "#86E97C")
        ]),
        ("Mystery level", [
            (57, "There is just enough intrigue to make people curious.", "#A98BFF"),
            (74, "You give layered, interesting, hard-to-pin-down energy.", "#5ED0FF"),
            (82, "You look like someone with a few great stories people want to hear.", "#FF78B2")
        ])
    ]

    private let assumptionPool = [
        AssumptionItem(title: "The calm one", description: "People may assume you stay composed and make others feel settled."),
        AssumptionItem(title: "Social glue", description: "You seem like the friend who can make almost any room feel fun."),
        AssumptionItem(title: "Secret weapon", description: "There is a subtle star quality that makes people think you are more interesting than you first reveal."),
        AssumptionItem(title: "Taste level: high", description: "Your style suggests you notice details and care about your vibe in a creative way."),
        AssumptionItem(title: "Low-drama energy", description: "You come across as someone who protects your peace and keeps things positive.")
    ]

    func generateProfile(seed: Int, isPremium: Bool, faceDetected: Bool) -> VibeResult {
        let normalizedSeed = abs(seed)
        let headline = positiveHeadlines[normalizedSeed % positiveHeadlines.count]

        let traits = traitPools.enumerated().map { offset, pair in
            let options = pair.values
            let choice = options[(normalizedSeed + offset) % options.count]
            let bonus = faceDetected ? 4 : 0
            return VibeTrait(
                title: pair.title,
                score: min(choice.0 + bonus, 99),
                summary: choice.1,
                accentHex: choice.2
            )
        }
        .sorted { $0.title < $1.title }

        let assumptionCount = isPremium ? 4 : 2
        let assumptions = Array(assumptionPool.shuffled(using: SeededRandomNumberGenerator(seed: UInt64(normalizedSeed))).prefix(assumptionCount))

        let disclaimer = "For fun only — this is a playful style read, not a psychological or scientific assessment."

        return VibeResult(
            headline: headline,
            disclaimer: disclaimer,
            traits: traits,
            assumptions: assumptions,
            imageData: nil,
            isPremiumLocked: !isPremium
        )
    }
}

struct SeededRandomNumberGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        self.state = seed == 0 ? 0x12345678 : seed
    }

    mutating func next() -> UInt64 {
        state = 2862933555777941757 &* state &+ 3037000493
        return state
    }
}
