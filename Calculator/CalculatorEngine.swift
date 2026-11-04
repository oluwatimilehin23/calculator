import Foundation

/// The four arithmetic operators.
enum Operation: String, CaseIterable {
    case add = "+"
    case subtract = "−"
    case multiply = "×"
    case divide = "÷"

    /// × and ÷ bind tighter than + and −.
    var isMultiplicative: Bool { self == .multiply || self == .divide }

    func apply(_ lhs: Decimal, _ rhs: Decimal) -> Decimal? {
        switch self {
        case .add: return lhs + rhs
        case .subtract: return lhs - rhs
        case .multiply: return lhs * rhs
        case .divide: return rhs == 0 ? nil : lhs / rhs
        }
    }
}

/// Calculator logic modeled on the iPhone calculator:
/// operator precedence (2 + 3 × 4 = 14), repeat "=", percent, sign toggle, C / AC.
struct CalculatorEngine {
    static let maxDigits = 9

    /// Raw text on screen (no thousands separators).
    private(set) var display = "0"
    /// The operator that is highlighted, waiting for its right-hand number.
    private(set) var selectedOperation: Operation?
    private(set) var hasError = false

    private var isTyping = false
    private var value: Decimal = 0
    private var addPending: (lhs: Decimal, op: Operation)?
    private var mulPending: (lhs: Decimal, op: Operation)?
    private var lastOperation: (op: Operation, rhs: Decimal)?

    /// "C" clears the current entry, "AC" clears everything.
    var clearLabel: String { isTyping ? "C" : "AC" }

    /// Display text with thousands separators, e.g. "1,234,567.89".
    var formattedDisplay: String {
        if hasError || display.contains("e") { return display }
        let negative = display.hasPrefix("-")
        let unsigned = negative ? String(display.dropFirst()) : display
        let parts = unsigned.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: false)
        var integer = String(parts[0])
        var grouped = ""
        while integer.count > 3 {
            grouped = "," + integer.suffix(3) + grouped
            integer = String(integer.dropLast(3))
        }
        grouped = integer + grouped
        if parts.count > 1 { grouped += "." + parts[1] }
        return (negative ? "-" : "") + grouped
    }

    // MARK: - Input

    mutating func inputDigit(_ digit: Int) {
        guard (0...9).contains(digit) else { return }
        if hasError { reset() }
        let d = String(digit)
        if !isTyping {
            display = d
            isTyping = true
        } else if display == "0" {
            display = d
        } else if display == "-0" {
            display = "-" + d
        } else if digitCount(display) < Self.maxDigits {
            display += d
        }
        selectedOperation = nil
    }

    mutating func inputDecimal() {
        if hasError { reset() }
        if !isTyping {
            display = "0."
            isTyping = true
        } else if !display.contains("."), digitCount(display) < Self.maxDigits {
            display += "."
        }
        selectedOperation = nil
    }

    /// Removes the last typed character (swipe on the display).
    mutating func backspace() {
        guard isTyping, !hasError else { return }
        display.removeLast()
        if display.isEmpty || display == "-" { display = "0" }
    }

    mutating func toggleSign() {
        if hasError { return }
        if !isTyping && (selectedOperation != nil || value.isZero) {
            // Start typing a negative number for the next operand.
            display = "-0"
            isTyping = true
            selectedOperation = nil
            return
        }
        if display.hasPrefix("-") {
            display.removeFirst()
        } else {
            display = "-" + display
        }
        if !isTyping { value = -value }
    }

    mutating func percent() {
        if hasError { return }
        var result = currentValue / 100
        // iPhone behavior: 50 + 10% means 50 + (10% of 50) = 55.
        if mulPending == nil, let add = addPending {
            result = add.lhs * currentValue / 100
        }
        show(result)
    }

    mutating func clear() {
        if isTyping {
            display = "0"
            isTyping = false
            value = 0
        } else {
            reset()
        }
    }

    // MARK: - Operators

    mutating func setOperation(_ op: Operation) {
        if hasError { return }
        var operand = currentValue

        // Pressing a different operator right after another one replaces it.
        if !isTyping, selectedOperation != nil {
            if let mul = mulPending {
                operand = mul.lhs
                mulPending = nil
            } else if let add = addPending {
                operand = add.lhs
                addPending = nil
            }
        }

        if op.isMultiplicative {
            if let mul = mulPending {
                guard let r = mul.op.apply(mul.lhs, operand) else { return fail() }
                operand = r
            }
            mulPending = (operand, op)
        } else {
            if let mul = mulPending {
                guard let r = mul.op.apply(mul.lhs, operand) else { return fail() }
                operand = r
                mulPending = nil
            }
            if let add = addPending {
                guard let r = add.op.apply(add.lhs, operand) else { return fail() }
                operand = r
            }
            addPending = (operand, op)
        }

        show(operand)
        selectedOperation = op
    }

    mutating func equals() {
        if hasError { return }
        let rhs = currentValue

        if mulPending == nil, addPending == nil {
            // Repeat the last operation: 2 + 3 = = = gives 5, 8, 11.
            guard let last = lastOperation else {
                show(rhs)
                return
            }
            guard let r = last.op.apply(rhs, last.rhs) else { return fail() }
            show(r)
            return
        }

        var result = rhs
        if let mul = mulPending {
            lastOperation = (mul.op, rhs)
            guard let r = mul.op.apply(mul.lhs, result) else { return fail() }
            result = r
        } else if let add = addPending {
            lastOperation = (add.op, rhs)
        }
        if let add = addPending {
            guard let r = add.op.apply(add.lhs, result) else { return fail() }
            result = r
        }
        mulPending = nil
        addPending = nil
        show(result)
    }

    // MARK: - Helpers

    private var currentValue: Decimal {
        isTyping ? (Decimal(string: display, locale: Locale(identifier: "en_US_POSIX")) ?? 0) : value
    }

    private func digitCount(_ s: String) -> Int {
        s.filter(\.isNumber).count
    }

    private mutating func show(_ result: Decimal) {
        value = result
        display = Self.format(result)
        isTyping = false
        selectedOperation = nil
        if display == "Error" { hasError = true }
    }

    private mutating func fail() {
        reset()
        display = "Error"
        hasError = true
    }

    private mutating func reset() {
        self = CalculatorEngine()
    }

    /// Formats a result to fit the screen: up to 9 significant digits,
    /// switching to scientific notation for very large or very small numbers.
    static func format(_ number: Decimal) -> String {
        if number.isNaN { return "Error" }
        if number.isZero { return "0" }
        let ns = NSDecimalNumber(decimal: number)
        let magnitude = abs(ns.doubleValue)
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.usesGroupingSeparator = false
        if magnitude >= 1e9 || magnitude < 1e-8 {
            formatter.numberStyle = .scientific
            formatter.usesSignificantDigits = true
            formatter.maximumSignificantDigits = 6
            formatter.exponentSymbol = "e"
        } else {
            formatter.numberStyle = .decimal
            formatter.usesSignificantDigits = true
            formatter.maximumSignificantDigits = maxDigits
        }
        guard let text = formatter.string(from: ns) else { return "Error" }
        return text == "-0" ? "0" : text
    }
}
