import Foundation

public extension Vault.SecretEngines.TransitClient {
    struct EncryptionKey<T: Decodable & Sendable>: Decodable, Sendable {
        public let allowPlaintextBackup: Bool?
        public let autoRotatePeriod: Int?
        public let deletionAllowed: Bool?
        public let derived: Bool?
        public let exportable: Bool?
        public let importedKey: Bool?
        public let keys: T?
        public let latestVersion: Int?
        public let minimumAvailableVersion: Int?
        public let minimumDecryptionVersion: Int?
        public let minimumEncryptionVersion: Int?
        public let name: String?
        public let supportsEncryption: Bool?
        public let supportsDecryption: Bool?
        public let supportsDerivation: Bool?
        public let supportsSigning: Bool?
        public let type: KeyType?

        enum CodingKeys: String, CodingKey {
            case allowPlaintextBackup = "allow_plaintext_backup"
            case autoRotatePeriod = "auto_rotate_period"
            case deletionAllowed = "deletion_allowed"
            case derived
            case exportable
            case importedKey = "imported_key"
            case keys
            case latestVersion = "latest_version"
            case minimumAvailableVersion = "min_available_version"
            case minimumDecryptionVersion = "min_decryption_version"
            case minimumEncryptionVersion = "min_encryption_version"
            case name
            case supportsEncryption = "supports_encryption"
            case supportsDecryption = "supports_decryption"
            case supportsDerivation = "supports_derivation"
            case supportsSigning = "supports_signing"
            case type
        }
    }
}
