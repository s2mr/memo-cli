import GRDB

struct Text: Codable, FetchableRecord, PersistableRecord {
    var id: Int64?
    var text: String
}

final class Database {
    let dbQueue: DatabaseQueue

    init() throws {
        self.dbQueue = try DatabaseQueue(path: NSHomeDirectory() + "/Desktop/testdb.sqlite")
    }

    func configure() throws {
        try dbQueue.write { db in
            try? db.create(table: "text") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("text", .text).notNull()
            }
        }
    }

    func list() throws -> [Text] {
        try dbQueue.read { db in
            try Text.fetchAll(db)
        }
    }

    func insert(text: Text) throws {
        try dbQueue.write { db in
            try text.insert(db)
        }
    }

    func delete(id: Int64) throws {
        _ = try dbQueue.write { db in
            try Text.deleteOne(db, key: id)
        }
    }
}
