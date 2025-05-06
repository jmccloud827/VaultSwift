import Foundation

public extension Vault.Transit {
    struct ImportKeyVersionOptions: Encodable, Sendable {
        public let base64EncodedCipherText: Bool?
        public let hashType: HashType?
        
        public init(base64EncodedCipherText: Bool?, hashType: HashType?) {
            self.base64EncodedCipherText = base64EncodedCipherText
            self.hashType = hashType
        }
        
        enum CodingKeys: String, CodingKey {
            case base64EncodedCipherText = "ciphertext"
            case hashType = "hash_function"
        }
    }
}
