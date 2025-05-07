import Foundation

public extension Vault.SecretEngines.GoogleCloudKMSClient {
    struct DecryptResponse: Decodable, Sendable {
        public let plainText: String?
        
        enum CodingKeys: String, CodingKey {
            case plainText = "plaintext"
        }
    }
}
