import Foundation

public extension Vault.SecretEngines.TransitClient {
    struct EncryptResponse: Decodable, Sendable {
        public let cipherText: String?
        public let keyVersion: String?
        public let batchResults: [Self]?
        
        enum CodingKeys: String, CodingKey {
            case cipherText = "ciphertext"
            case keyVersion = "key_version"
            case batchResults = "batch_results"
        }
    }
}
