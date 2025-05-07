import Foundation

public extension Vault.SecretEngines.TransitClient {
    struct RewrapOptions: Encodable, Sendable {
        public let keyVersion: Int?
        public let cipherText: String?
        public let base64EncodedContext: String?
        public let nonce: String??
        public let partialFailureResponseCode: Int?
        public let batchedItems: [Self]?
        
        public init(keyVersion: Int?,
                    cipherText: String?,
                    base64EncodedContext: String?,
                    nonce: String?,
                    partialFailureResponseCode: Int? = 400,
                    batchedItems: [Self]?) {
            self.keyVersion = keyVersion
            self.cipherText = cipherText
            self.base64EncodedContext = base64EncodedContext
            self.nonce = nonce
            self.partialFailureResponseCode = partialFailureResponseCode
            self.batchedItems = batchedItems
        }
        
        enum CodingKeys: String, CodingKey {
            case keyVersion = "key_version"
            case cipherText = "ciphertext"
            case base64EncodedContext = "context"
            case nonce
            case partialFailureResponseCode = "partial_failure_response_code"
            case batchedItems = "batch_input"
        }
    }
}
