import Foundation

public extension Vault.Transit {
    struct CreateKeyOptions: Encodable, Sendable {
        public let convergentEncryption: Bool?
        public let derived: Bool?
        public let exportable: Bool?
        public let allowPlaintextBackup: Bool?
        public let type: KeyType?
        public let keySize: Int?
        public let autoRotatePeriod: Int?
        
        public init(convergentEncryption: Bool?,
                    derived: Bool?,
                    exportable: Bool?,
                    allowPlaintextBackup: Bool?,
                    type: KeyType? = .aes256_gcm96,
                    keySize: Int?,
                    autoRotatePeriod: Int?) {
            self.convergentEncryption = convergentEncryption
            self.derived = derived
            self.exportable = exportable
            self.allowPlaintextBackup = allowPlaintextBackup
            self.type = type
            self.keySize = keySize
            self.autoRotatePeriod = autoRotatePeriod
        }
        
        enum CodingKeys: String, CodingKey {
            case convergentEncryption = "convergent_encryption"
            case derived
            case exportable
            case allowPlaintextBackup = "allow_plaintext_backup"
            case type
            case keySize = "key_size"
            case autoRotatePeriod = "auto_rotate_period"
        }
    }
}
