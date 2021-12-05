import Foundation
import ArgumentParser
import GRDB

struct DB: ParsableCommand {
    static var configuration = CommandConfiguration(
        subcommands: [Insert.self, List.self, Delete.self]
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
            texts.forEach {
                print("\($0.id ?? 0): \($0.text)")
            }
        }
    }
}
