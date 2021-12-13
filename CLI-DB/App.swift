@main
struct App {
    static func main() throws {
        do {
            let database = try Database()
            try database.configure()
        } catch {
            print("Error!", to: &standardError)
        }

        DB.main()
    }
}

