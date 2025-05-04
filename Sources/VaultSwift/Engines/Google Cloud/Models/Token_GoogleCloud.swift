import Foundation

public extension Vault.GoogleCloud {
    struct Token: Decodable, Sendable {
        public let token: String
        public let expiresAtSeconds: Int
        public let tokenTimeToLive: Int
        
        enum CodingKeys: String, CodingKey {
            case token = "token"
            case expiresAtSeconds = "expires_at_seconds"
            case tokenTimeToLive = "token_ttl"
        }
    }
}
