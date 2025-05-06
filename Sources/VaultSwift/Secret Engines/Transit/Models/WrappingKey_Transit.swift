import Foundation

public extension Vault.Transit {
    struct WrappingKey: Decodable, Sendable {
        public let publicKey: String?
        
        enum CodingKeys: String, CodingKey {
            case publicKey = "public_key"
        }
    }
}
