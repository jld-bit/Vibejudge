# Vibejudge

Vibejudge is a colorful SwiftUI iPhone app concept that lets users upload a selfie and receive a playful, positive first-impression personality-style breakdown.

## Included structure
- `App/`: app entry point.
- `Models/`: result, trait, and premium feature models.
- `Services/`: generator logic, optional Vision-based face detection, local history persistence, and a StoreKit 2-only premium manager stub.
- `ViewModels/`: shared app state and MVVM orchestration.
- `Views/Screens/`: upload, result, saved, and premium screens.
- `Views/Components/`: reusable colorful background and glow-card UI components.

## Notes
- Outputs are explicitly framed as entertainment, not psychology.
- All generated copy stays positive and non-harmful.
- The premium flow uses StoreKit 2 only.
- This repository includes a `project.yml` file for XcodeGen, so you can generate an iOS app project with `xcodegen generate` on macOS.
