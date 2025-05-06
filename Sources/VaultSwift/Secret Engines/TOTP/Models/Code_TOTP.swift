import Foundation

public extension Vault.TOTP {
    struct Code: Decodable, Sendable {
        public let code: String?
        
        enum CodingKeys: String, CodingKey {
            case code
        }
    }
}
