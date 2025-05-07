import Foundation

public extension Vault.SystemBackend {
    struct RekeyBackup: Decodable, Sendable {
        public let nonce: String?
        public let pgpFingerprintToEncryptedKeyMap: [String: String]?

        enum CodingKeys: String, CodingKey {
            case nonce
            case pgpFingerprintToEncryptedKeyMap = "keys"
        }
    }
}
