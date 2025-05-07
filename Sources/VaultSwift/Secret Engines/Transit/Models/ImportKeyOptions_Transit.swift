import Foundation

public extension Vault.SecretEngines.TransitClient {
    struct ImportKeyOptions: Encodable, Sendable {
        public let base64EncodedCipherText: Bool?
        public let hashType: HashFunctionType?
        public let type: KeyType?
        public let allowRotation: Bool?
        public let derived: Bool?
        public let base64EncodedKeyDerivationContext: String?
        public let exportable: Bool?
        public let allowPlaintextBackup: Bool?
        public let autoRotatePeriod: Int?
        
        public init(base64EncodedCipherText: Bool?,
                    hashType: HashFunctionType?,
                    type: KeyType?,
                    allowRotation: Bool?,
                    derived: Bool?,
                    base64EncodedKeyDerivationContext: String?,
                    exportable: Bool?,
                    allowPlaintextBackup: Bool?,
                    autoRotatePeriod: Int?) {
            self.base64EncodedCipherText = base64EncodedCipherText
            self.hashType = hashType
            self.type = type
            self.allowRotation = allowRotation
            self.derived = derived
            self.base64EncodedKeyDerivationContext = base64EncodedKeyDerivationContext
            self.exportable = exportable
            self.allowPlaintextBackup = allowPlaintextBackup
            self.autoRotatePeriod = autoRotatePeriod
        }
        
        enum CodingKeys: String, CodingKey {
            case base64EncodedCipherText = "ciphertext"
            case hashType = "hash_function"
            case type
            case allowRotation = "allow_rotation"
            case derived
            case base64EncodedKeyDerivationContext = "context"
            case exportable
            case allowPlaintextBackup = "allow_plaintext_backup"
            case autoRotatePeriod = "auto_rotate_period"
        }
    }
}
