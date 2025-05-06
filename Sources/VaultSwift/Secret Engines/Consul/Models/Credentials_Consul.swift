import Foundation

public extension Vault.Consul {
    struct Credentials: Decodable, Sendable {
        public let token: String
        
        enum CodingKeys: String, CodingKey {
            case token = "token"
        }
    }
}
