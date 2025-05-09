import Foundation

public extension Vault.SystemBackend {
    struct RekeyProgress: Decodable, Sendable {
        public let nonce: String?
        public let complete: Bool?
        public let masterKeys: [String]?
        public let base64MasterKeys: [String]?
        public let pgpFingerprints: [String]?
        public let backup: Bool?

        enum CodingKeys: String, CodingKey {
            case nonce
            case complete
            case masterKeys = "keys"
            case base64MasterKeys = "keys_base64"
            case pgpFingerprints = "pgp_fingerprints"
            case backup
        }
    }
}
