import Foundation

public extension Vault.SystemBackend {
    struct RekeyRequest: Encodable, Sendable {
        public let secretShares: Int?
        public let secretThreshold: Int?
        public let pgpKeys: [String]?
        public let backup: Bool
        
        public init(secretShares: Int?, secretThreshold: Int?, pgpKeys: [String]? = nil, backup: Bool = false) {
            self.secretShares = secretShares
            self.secretThreshold = secretThreshold
            self.pgpKeys = pgpKeys
            self.backup = backup
        }

        enum CodingKeys: String, CodingKey {
            case secretShares = "secret_shares"
            case secretThreshold = "secret_threshold"
            case pgpKeys = "pgp_keys"
            case backup
        }
    }
}
