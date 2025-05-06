import Foundation

public extension Vault.TOTP {
    struct CreateKeyResponse: Decodable, Sendable {
        public let barcode: String?
        public let url: String?
        
        enum CodingKeys: String, CodingKey {
            case barcode
            case url
        }
    }
}
