import Foundation

public extension Vault.PKI {
    struct Credentials: Decodable, Sendable {
        public let privateKeyContent: String?
        public let expiration: Int?
        
        enum CodingKeys: String, CodingKey {
            case privateKeyContent = "private_key"
            case expiration
        }
    }
}
