import Foundation

final class HistoryStore {
    private let key = "saved.vibejudge.results"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    func load() -> [VibeResult] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let results = try? decoder.decode([VibeResult].self, from: data) else {
            return []
        }

        return results.sorted { $0.createdAt > $1.createdAt }
    }

    func save(_ results: [VibeResult]) {
        guard let data = try? encoder.encode(results) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
