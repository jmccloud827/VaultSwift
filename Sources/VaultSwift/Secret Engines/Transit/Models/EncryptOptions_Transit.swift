import Foundation

public extension Vault.SecretEngines.TransitClient {
    struct EncryptOptions: Encodable, Sendable {
        public let base64EncodedPlainText: String?
        public let base64EncodedContext: String?
        public let keyVersion: Int?
        public let nonce: String?
        public let keyType: KeyType?
        public let convergentEncryption: Bool?
        public let partialFailureResponseCode: Int?
        public let batchedItems: [Self]?
        
        public init(base64EncodedPlainText: String?,
                    base64EncodedContext: String?,
                    keyVersion: Int?,
                    nonce: String?,
                    keyType: KeyType? = .aes256_gcm96,
                    convergentEncryption: Bool?,
                    partialFailureResponseCode: Int? = 400,
                    batchedItems: [Self]?) {
            self.base64EncodedPlainText = base64EncodedPlainText
            self.base64EncodedContext = base64EncodedContext
            self.keyVersion = keyVersion
            self.nonce = nonce
            self.keyType = keyType
            self.convergentEncryption = convergentEncryption
            self.partialFailureResponseCode = partialFailureResponseCode
            self.batchedItems = batchedItems
        }
        
        enum CodingKeys: String, CodingKey {
            case base64EncodedPlainText = "plaintext"
            case base64EncodedContext = "context"
            case keyVersion = "key_version"
            case nonce
            case keyType = "type"
            case convergentEncryption = "convergent_encryption"
            case partialFailureResponseCode = "partial_failure_response_code"
            case batchedItems = "batch_input"
        }
    }
}
