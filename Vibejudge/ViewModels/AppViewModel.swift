import Foundation
import SwiftUI

@MainActor
final class AppViewModel: ObservableObject {
    @Published var selectedImageData: Data?
    @Published var currentResult: VibeResult?
    @Published var savedResults: [VibeResult] = []
    @Published var remainingFreeScans = 3
    @Published var isGenerating = false
    @Published var generatorMessage = "Upload a selfie for a playful, positive first-impression read."

    let premiumManager = PremiumManager()

    private let generator: VibeGenerating
    private let faceDetectionService = FaceDetectionService()
    private let historyStore = HistoryStore()

    init(generator: VibeGenerating = VibeGenerator()) {
        self.generator = generator
        self.savedResults = historyStore.load()
    }

    var canGenerate: Bool {
        selectedImageData != nil && (remainingFreeScans > 0 || premiumManager.isPremiumUnlocked)
    }

    func generate() async {
        guard let selectedImageData else {
            generatorMessage = "Choose a selfie first."
            return
        }
        guard canGenerate else {
            generatorMessage = "You have used your free scans. Go premium for unlimited full breakdowns."
            return
        }

        isGenerating = true
        defer { isGenerating = false }

        let detectedFace = await faceDetectionService.containsFace(in: selectedImageData)
        var result = generator.generateProfile(
            seed: selectedImageData.hashValue,
            isPremium: premiumManager.isPremiumUnlocked,
            faceDetected: detectedFace
        )
        result = VibeResult(
            id: result.id,
            createdAt: result.createdAt,
            headline: result.headline,
            disclaimer: result.disclaimer,
            traits: result.traits,
            assumptions: result.assumptions,
            imageData: selectedImageData,
            isPremiumLocked: result.isPremiumLocked
        )

        currentResult = result
        if !premiumManager.isPremiumUnlocked {
            remainingFreeScans = max(remainingFreeScans - 1, 0)
        }
        generatorMessage = detectedFace ? "Vibe read ready." : "Vibe read ready. Tip: a clear selfie can improve face-aware styling."
    }

    func saveCurrentResult() {
        guard let currentResult else { return }
        guard premiumManager.isPremiumUnlocked || savedResults.count < 1 else {
            generatorMessage = "Premium unlocks unlimited history. Free mode keeps your latest favorite only."
            savedResults = [currentResult]
            historyStore.save(savedResults)
            return
        }

        savedResults.insert(currentResult, at: 0)
        historyStore.save(savedResults)
        generatorMessage = "Result saved."
    }

    func removeSavedResult(id: UUID) {
        savedResults.removeAll { $0.id == id }
        historyStore.save(savedResults)
    }
}
