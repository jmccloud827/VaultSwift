import Foundation

public extension Vault.TOTP {
    struct CodeValidity: Decodable, Sendable {
        public let isValid: Bool
        
        enum CodingKeys: String, CodingKey {
            case isValid = "valid"
        }
    }
}
