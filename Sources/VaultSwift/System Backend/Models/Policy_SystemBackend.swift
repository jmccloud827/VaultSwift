import Foundation

public extension Vault.SystemBackend {
    struct Policy: Codable, Sendable {
        public let name: String?
        public let rules: String?
        
        public init(name: String?, rules: String?) {
            self.name = name
            self.rules = rules
        }
        
        enum CodingKeys: String, CodingKey {
            case name
            case rules
        }
    }
}
