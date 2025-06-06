import Foundation

public extension Vault.SecretEngines.GoogleCloudKMSClient {
    struct ReEncryptResponse: Decodable, Sendable {
        public let keyVersion: Int?
        public let cipherText: String?
        
        enum CodingKeys: String, CodingKey {
            case keyVersion = "key_version"
            case cipherText = "ciphertext"
        }
    }
}
