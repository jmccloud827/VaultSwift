import Foundation

public extension Vault.SystemBackend {
    struct ACLPolicy: Codable, Sendable {
        public let name: String?
        public let policy: String?
        
        public init(name: String?, policy: String?) {
            self.name = name
            self.policy = policy
        }
        
        enum CodingKeys: String, CodingKey {
            case name
            case policy
        }
    }
}
