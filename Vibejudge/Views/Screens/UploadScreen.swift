import PhotosUI
import SwiftUI

struct UploadScreen: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    @State private var photoItem: PhotosPickerItem?

    var body: some View {
        NavigationStack {
            ZStack {
                CosmicBackground()

                ScrollView {
                    VStack(spacing: 20) {
                        heroCard
                        uploaderCard

                        if let result = appViewModel.currentResult {
                            ResultScreen(result: result)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Vibejudge")
        }
    }

    private var heroCard: some View {
        GlowCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Your selfie, but make it a glowing first-impression read")
                    .font(.largeTitle.bold())
                Text("Fun, upbeat personality-style insights only. No diagnosis, no harsh takes, no false claims of accuracy.")
                    .foregroundStyle(.white.opacity(0.78))
                Label("\(appViewModel.remainingFreeScans) free scans left", systemImage: "bolt.fill")
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.pink.opacity(0.2), in: Capsule())
            }
        }
    }

    private var uploaderCard: some View {
        GlowCard {
            VStack(spacing: 16) {
                PhotosPicker(selection: $photoItem, matching: .images) {
                    VStack(spacing: 10) {
                        Image(systemName: "camera.metering.center.weighted")
                            .font(.system(size: 38))
                        Text("Upload or take a selfie")
                            .font(.headline)
                        Text("Use the system photo picker or camera-enabled source when running on device.")
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .strokeBorder(.white.opacity(0.22), style: StrokeStyle(lineWidth: 1.2, dash: [7]))
                    )
                }
                .onChange(of: photoItem) { _, newValue in
                    guard let newValue else { return }
                    Task {
                        appViewModel.selectedImageData = try? await newValue.loadTransferable(type: Data.self)
                    }
                }

                Button {
                    Task { await appViewModel.generate() }
                } label: {
                    HStack {
                        if appViewModel.isGenerating {
                            ProgressView()
                        }
                        Text("Judge my vibe")
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(colors: [.pink, .purple, .cyan], startPoint: .leading, endPoint: .trailing),
                        in: RoundedRectangle(cornerRadius: 20, style: .continuous)
                    )
                }
                .disabled(!appViewModel.canGenerate || appViewModel.isGenerating)

                Text(appViewModel.generatorMessage)
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.76))
                    .multilineTextAlignment(.center)
            }
        }
    }
}
