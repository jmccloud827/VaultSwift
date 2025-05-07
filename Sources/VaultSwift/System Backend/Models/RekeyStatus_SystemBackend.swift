import Foundation

public extension Vault.SystemBackend {
    struct RekeyStatus: Decodable, Sendable {
        public let nonce: String?
        public let started: Bool?
        public let secretThreshold: Int?
        public let secretShares: Int?
        public let unsealKeysProvided: Int?
        public let requiredUnsealKeys: Int?
        public let pgpFingerprints: [String]?
        public let backup: Bool?

        enum CodingKeys: String, CodingKey {
            case nonce
            case started
            case secretThreshold = "t"
            case secretShares = "n"
            case unsealKeysProvided = "progress"
            case requiredUnsealKeys = "required"
            case pgpFingerprints = "pgp_fingerprints"
            case backup
        }
    }
}
