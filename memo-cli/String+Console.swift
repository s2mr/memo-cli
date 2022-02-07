extension String {
    enum ConsoleColor: Int {
        case black = 30
        case red
        case green
        case yellow
        case blue
        case magenta
        case cyan
        case white
    }

    enum ConsoleStyle: Int {
        case `default`
        case bold
        case thin
        case italic
        case underline
        case blink
        case fastBrink
        case reverseFrontBack
        case hidden
        case cancel
    }

    func colored(_ color: ConsoleColor, style: ConsoleStyle = .default) -> String {
        "\u{001B}[\(style.rawValue);\(color.rawValue)m\(self)\u{001B}[0m"
    }
}
