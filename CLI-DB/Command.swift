import Foundation
import ArgumentParser
import GRDB

struct DB: ParsableCommand {
    static var configuration = CommandConfiguration(
        subcommands: [
            List.self,
            Insert.self,
            Delete.self,
            ForwardingCommand<List>.self,
            ForwardingCommand<Insert>.self,
            ForwardingCommand<Delete>.self
        ],
        defaultSubcommand: List.self
    )
}

extension DB {
    struct Insert: ParsableCommand {
        @Argument
        var text: String

        func run() throws {
            let db = try Database()
            try db.insert(text: Text(text: text))
        }
    }

    struct Delete: ParsableCommand {
        @Argument
        var id: Int64

        func run() throws {
            let db = try Database()
            try db.delete(id: id)
        }
    }

    struct List: ParsableCommand {
        func run() throws {
            let db = try Database()
            let texts = try db.list()
            guard texts.count > .zero else {
                return print("No entry.")
            }
            texts.forEach {
                print("\($0.id ?? 0): \($0.text)")
            }
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
