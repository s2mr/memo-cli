@main
struct App {
    static func main() throws {
        let database = try Database()
        try database.configure()
        
        DB.main()
    }
}
