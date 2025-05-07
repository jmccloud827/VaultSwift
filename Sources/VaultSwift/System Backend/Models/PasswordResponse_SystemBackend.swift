import Foundation

public extension Vault.SystemBackend {
    struct PasswordResponse: Decodable, Sendable {
        public let password: String?
        
        enum CodingKeys: String, CodingKey {
            case password
        }
    }
}
