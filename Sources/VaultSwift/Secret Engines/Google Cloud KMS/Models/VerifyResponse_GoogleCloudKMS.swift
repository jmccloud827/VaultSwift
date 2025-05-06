import Foundation

public extension Vault.GoogleCloudKMS {
    struct VerifyResponse: Decodable, Sendable {
        public let valid: Bool
        
        enum CodingKeys: String, CodingKey {
            case valid
        }
    }
}
