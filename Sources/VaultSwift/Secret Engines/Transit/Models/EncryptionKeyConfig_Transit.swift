import Foundation

public extension Vault.SecretEngines.TransitClient {
    struct EncryptionKeyConfig: Encodable, Sendable {
        public let deletionAllowed: Bool?
        public let exportable: Bool?
        public let allowPlaintextBackup: Bool?
        public let minimumDecryptionVersion: Int?
        public let minimumEncryptionVersion: Int?
        public let autoRotatePeriod: Int?
        
        public init(deletionAllowed: Bool?,
                    exportable: Bool?,
                    allowPlaintextBackup: Bool?,
                    minimumDecryptionVersion: Int?,
                    minimumEncryptionVersion: Int?,
                    autoRotatePeriod: Int?) {
            self.deletionAllowed = deletionAllowed
            self.exportable = exportable
            self.allowPlaintextBackup = allowPlaintextBackup
            self.minimumDecryptionVersion = minimumDecryptionVersion
            self.minimumEncryptionVersion = minimumEncryptionVersion
            self.autoRotatePeriod = autoRotatePeriod
        }
        
        enum CodingKeys: String, CodingKey {
            case deletionAllowed = "deletion_allowed"
            case exportable
            case allowPlaintextBackup = "allow_plaintext_backup"
            case minimumDecryptionVersion = "min_decryption_version"
            case minimumEncryptionVersion = "min_encryption_version"
            case autoRotatePeriod = "auto_rotate_period"
        }
    }
}
