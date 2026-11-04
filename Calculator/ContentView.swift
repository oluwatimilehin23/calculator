import SwiftUI
import UIKit

/// One key on the keypad.
enum CalcButton: Hashable {
    case digit(Int)
    case decimal
    case operation(Operation)
    case equals
    case clear
    case sign
    case percent

    enum Style { case number, function, operation }

    var style: Style {
        switch self {
        case .digit, .decimal: return .number
        case .clear, .sign, .percent: return .function
        case .operation, .equals: return .operation
        }
    }
}

struct ContentView: View {
    @State private var engine = CalculatorEngine()

    private let rows: [[CalcButton]] = [
        [.clear, .sign, .percent, .operation(.divide)],
        [.digit(7), .digit(8), .digit(9), .operation(.multiply)],
        [.digit(4), .digit(5), .digit(6), .operation(.subtract)],
        [.digit(1), .digit(2), .digit(3), .operation(.add)],
        [.digit(0), .decimal, .equals],
    ]

    private let spacing: CGFloat = 14

    var body: some View {
        GeometryReader { geo in
            let side = min((geo.size.width - spacing * 5) / 4, 90)

            VStack(spacing: spacing) {
                Spacer()

                Text(engine.formattedDisplay)
                    .font(.system(size: 90, weight: .light))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.35)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, spacing + 8)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 20).onEnded { value in
                            if abs(value.translation.width) > 30 { engine.backspace() }
                        }
                    )
                    .accessibilityLabel("Result")
                    .accessibilityValue(engine.formattedDisplay)

                ForEach(rows, id: \.self) { row in
                    HStack(spacing: spacing) {
                        ForEach(row, id: \.self) { button in
                            key(button, side: side)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, spacing)
        }
        .background(Color.black.ignoresSafeArea())
    }

    // MARK: - Keys

    @ViewBuilder
    private func key(_ button: CalcButton, side: CGFloat) -> some View {
        let isZero = button == .digit(0)
        let width = isZero ? side * 2 + spacing : side

        Button {
            tap(button)
        } label: {
            label(for: button)
                .padding(.leading, isZero ? side * 0.38 : 0)
                .frame(width: width, height: side, alignment: isZero ? .leading : .center)
                .background(background(for: button))
                .foregroundStyle(foreground(for: button))
                .clipShape(Capsule())
        }
        .buttonStyle(PressStyle())
        .accessibilityLabel(accessibilityName(for: button))
    }

    private func label(for button: CalcButton) -> some View {
        Group {
            switch button {
            case .digit(let d): Text("\(d)")
            case .decimal: Text(".")
            case .operation(let op): Image(systemName: symbol(for: op))
            case .equals: Image(systemName: "equal")
            case .clear: Text(engine.clearLabel)
            case .sign: Image(systemName: "plus.forwardslash.minus")
            case .percent: Image(systemName: "percent")
            }
        }
        .font(.system(size: button.style == .number ? 38 : 32, weight: .medium))
    }

    private func symbol(for op: Operation) -> String {
        switch op {
        case .add: return "plus"
        case .subtract: return "minus"
        case .multiply: return "multiply"
        case .divide: return "divide"
        }
    }

    private func isSelected(_ button: CalcButton) -> Bool {
        if case .operation(let op) = button { return engine.selectedOperation == op }
        return false
    }

    private func background(for button: CalcButton) -> Color {
        switch button.style {
        case .number: return Color(white: 0.2)
        case .function: return Color(white: 0.65)
        case .operation: return isSelected(button) ? .white : .orange
        }
    }

    private func foreground(for button: CalcButton) -> Color {
        switch button.style {
        case .number: return .white
        case .function: return .black
        case .operation: return isSelected(button) ? .orange : .white
        }
    }

    private func accessibilityName(for button: CalcButton) -> String {
        switch button {
        case .digit(let d): return "\(d)"
        case .decimal: return "Decimal point"
        case .operation(.add): return "Add"
        case .operation(.subtract): return "Subtract"
        case .operation(.multiply): return "Multiply"
        case .operation(.divide): return "Divide"
        case .equals: return "Equals"
        case .clear: return engine.clearLabel == "C" ? "Clear" : "All clear"
        case .sign: return "Plus minus"
        case .percent: return "Percent"
        }
    }

    // MARK: - Actions

    private func tap(_ button: CalcButton) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        switch button {
        case .digit(let d): engine.inputDigit(d)
        case .decimal: engine.inputDecimal()
        case .operation(let op): engine.setOperation(op)
        case .equals: engine.equals()
        case .clear: engine.clear()
        case .sign: engine.toggleSign()
        case .percent: engine.percent()
        }
    }
}

/// Brightens a key while it is held down, like the iPhone calculator.
private struct PressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .brightness(configuration.isPressed ? 0.25 : 0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

#Preview {
    ContentView()
}
