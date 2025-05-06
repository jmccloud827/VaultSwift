import Foundation

public extension Vault.SystemBackend {
    struct AuditHash: Decodable, Sendable {
        public let hash: String?
        
        enum CodingKeys: String, CodingKey {
            case hash
        }
    }
}
