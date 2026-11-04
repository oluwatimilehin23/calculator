# Calculator

An iPhone-style calculator app for iOS, written in SwiftUI.

## Features

- Familiar iPhone calculator layout: round keys, orange operators, double-width 0
- Correct order of operations: `2 + 3 × 4 = 14`
- Repeat `=` to repeat the last operation (`2 + 3 = = =` → 5, 8, 11)
- `%`, `±`, `C` / `AC`, decimals, and an `Error` message when you divide by zero
- Swipe left or right on the number to delete the last digit
- Exact decimal math, so `0.1 + 0.2 = 0.3`
- Large numbers get thousands separators and switch to scientific notation when they don't fit
- Haptic feedback, VoiceOver labels, and a custom app icon

## Run it on your iPhone

You need a Mac with **Xcode 16 or later** (free from the Mac App Store).

1. Clone this repo and open `Calculator.xcodeproj` in Xcode.
2. Select the **Calculator** project → **Calculator** target → **Signing & Capabilities**,
   and choose your Apple ID under **Team** (a free account works).
   If Xcode says the bundle ID is taken, change it to something unique, e.g. `com.yourname.Calculator`.
3. Plug in your iPhone (or pick a simulator) and press **Run** (⌘R).
4. On your iPhone the first time: **Settings → General → VPN & Device Management**,
   trust your developer certificate. On iOS 16+ you also need to turn on
   **Settings → Privacy & Security → Developer Mode**.

Requires iOS 17 or later.

## Project layout

| File | What it does |
| --- | --- |
| `Calculator/CalculatorEngine.swift` | All the math and key-press logic |
| `Calculator/ContentView.swift` | The screen: display and keypad |
| `Calculator/CalculatorApp.swift` | App entry point |
| `Calculator/Assets.xcassets` | App icon |
