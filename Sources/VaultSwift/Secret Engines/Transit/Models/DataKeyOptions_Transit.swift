import Foundation

public extension Vault.SecretEngines.TransitClient {
    struct DataKeyOptions: Encodable, Sendable {
        public let base64EncodedContext: String?
        public let nonce: String?
        public let bits: Int?
        
        public init(base64EncodedContext: String?,
                    nonce: String? = nil,
                    bits: Int? = 256) {
            self.base64EncodedContext = base64EncodedContext
            self.nonce = nonce
            self.bits = bits
        }

        enum CodingKeys: String, CodingKey {
            case base64EncodedContext = "context"
            case nonce
            case bits
        }
    }
    
    enum DataKeyType: String, Encodable, Sendable {
        case plainText = "plaintext"
        case wrapped
    }
}
