import Foundation
import ArgumentParser
import GRDB

struct Memo: ParsableCommand {
    static var configuration = CommandConfiguration(
        subcommands: [
            Show.self,
            List.self,
            Insert.self,
            Remove.self,
            Drop.self,
            ForwardingCommand<Show>.self,
            ForwardingCommand<List>.self,
            ForwardingCommand<Insert>.self,
            ForwardingCommand<Remove>.self,
            ForwardingCommand<Drop>.self
        ],
        defaultSubcommand: List.self
    )
}

let pipeValue = FileHandle.standardInput.getStringFromPipe()

extension Memo {
    struct Insert: ParsableCommand {
        @Argument(wrappedValue: pipeValue ?? "")
        var text: String

        func validate() throws {
            if text.isEmpty {
                throw NSError(domain: "text must not be empty", code: -1)
            }
        }

        func run() throws {
            let db = try Database()
            try db.insert(text: Text(text: text))
        }
    }

    struct Remove: ParsableCommand {
        @Argument
        var id: Int64

        func run() throws {
            let db = try Database()
            guard let text = try db.get(id: id) else { return }
            try db.delete(id: id)
            print("[Deleted]", text.text)
        }
    }

    struct List: ParsableCommand {
        func run() throws {
            let db = try Database()
            let texts = try db.list()
            guard texts.count > .zero else {
                return print("No entry.")
            }
            texts.forEach { text in
                var value = String(text.text.prefix(100))
                if text.text.count > 100 {
                    value.append(" " + "  More  ".colored(.green, style: .bold))
                }
                print("\(text.id ?? 0): \(value)")
            }
        }
    }

    struct Show: ParsableCommand {
        @Argument
        var id: Int64

        func run() throws {
            let db = try Database()
            let text = try db.get(id: id)
            if let text = text {
                print("\(text.id ?? 0): \(text.text)")
            }
        }
    }

    struct Drop: ParsableCommand {
        func run() throws {
            let db = try Database()
            guard let last = try db.list().last else { return }
            try db.delete(id: last.id!)
            print("[Deleted]", last.id!, last.text)
        }
    }
}

struct ForwardingCommand<Base: ParsableCommand>: ParsableCommand {
    static var configuration: CommandConfiguration {
        var c = Base.configuration
        c.commandName = String(Base._commandName.prefix(1))
        c.abstract = "Alias for `\(Base._commandName)`"
        return c
    }

    @OptionGroup
    var command: Base

    mutating func run() throws {
        try command.run()
    }
}
