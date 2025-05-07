import Foundation

public extension Vault.SystemBackend.PluginsClient {
    struct Plugin: Decodable, Sendable {
        public let args: [String]?
        public let builtin: Bool?
        public let command: String?
        public let name: String?
        public let sha256: String?

        enum CodingKeys: String, CodingKey {
            case args
            case builtin
            case command
            case name
            case sha256
        }
    }
}
