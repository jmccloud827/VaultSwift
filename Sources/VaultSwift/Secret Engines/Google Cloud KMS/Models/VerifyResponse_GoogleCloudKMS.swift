import Foundation

public extension Vault.SecretEngines.GoogleCloudKMSClient {
    struct VerifyResponse: Decodable, Sendable {
        public let valid: Bool
        
        enum CodingKeys: String, CodingKey {
            case valid
        }
    }
}
