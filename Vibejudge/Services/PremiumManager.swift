import Foundation
import StoreKit

@MainActor
final class PremiumManager: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var isPremiumUnlocked = false
    @Published private(set) var statusMessage = "Unlock full reads, unlimited scans, and saved history."

    private let productIDs = ["com.vibejudge.premium.monthly"]

    func loadProducts() async {
        do {
            products = try await Product.products(for: productIDs)
            if products.isEmpty {
                statusMessage = "StoreKit products are not configured yet. Add the product in App Store Connect when ready."
            }
        } catch {
            statusMessage = "Unable to load products in this stub environment."
        }
    }

    func purchasePremium() async {
        guard let product = products.first else {
            statusMessage = "No product is available yet. This paywall is a StoreKit 2 stub."
            return
        }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                switch verification {
                case .verified:
                    isPremiumUnlocked = true
                    statusMessage = "Premium unlocked."
                case .unverified:
                    statusMessage = "Purchase could not be verified."
                }
            case .userCancelled:
                statusMessage = "Purchase cancelled."
            case .pending:
                statusMessage = "Purchase pending approval."
            @unknown default:
                statusMessage = "Unknown purchase state."
            }
        } catch {
            statusMessage = "Purchase failed: \(error.localizedDescription)"
        }
    }
}
