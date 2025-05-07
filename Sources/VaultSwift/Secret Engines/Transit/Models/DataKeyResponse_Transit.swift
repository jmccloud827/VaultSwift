import Foundation

public extension Vault.SecretEngines.TransitClient {
    struct DataKeyResponse: Decodable, Sendable {
        public let cipherText: String?
        public let keyVersion: Int?
        public let base64EncodedPlainText: String?

        enum CodingKeys: String, CodingKey {
            case cipherText = "ciphertext"
            case keyVersion = "key_version"
            case base64EncodedPlainText = "plaintext"
        }
    }
}
