import Foundation

extension FileHandle {
    /// - Workaround: get string value from pipe input
    func getStringFromPipe() -> String? {
        var input: Data?
        FileHandle.standardInput.readabilityHandler = { a in
            let data = a.availableData
            if data.count > 0 {
                input = data
            }
        }
        Thread.sleep(forTimeInterval: 0.01)
        return input.flatMap { input in
            String(data: input, encoding: .utf8)?
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}
