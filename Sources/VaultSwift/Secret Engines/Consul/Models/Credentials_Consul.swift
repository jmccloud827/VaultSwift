import Foundation

public extension Vault.SecretEngines.ConsulClient {
    struct Credentials: Decodable, Sendable {
        public let token: String
        
        enum CodingKeys: String, CodingKey {
            case token
        }
    }
}
