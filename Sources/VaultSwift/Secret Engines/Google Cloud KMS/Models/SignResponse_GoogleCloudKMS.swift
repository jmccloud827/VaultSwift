import Foundation

public extension Vault.SecretEngines.GoogleCloudKMSClient {
    struct SignResponse: Decodable, Sendable {
        public let signature: String
        
        enum CodingKeys: String, CodingKey {
            case signature
        }
    }
}
