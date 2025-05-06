import Foundation

public extension Vault.SystemBackend {
    struct InitOptions: Encodable, Sendable {
        public let pgpKeys: [String]?
        public let rootTokenPGPKey: String?
        public let secretShares: Int?
        public let secretThreshold: Int?
        public let storedShares: Int?
        public let recoveryShares: Int?
        public let recoveryThreshold: Int?
        public let recoveryPGPKeys: [String]?
        
        public init(pgpKeys: [String]?,
                   rootTokenPGPKey: String?,
                   secretShares: Int?,
                   secretThreshold: Int?,
                   storedShares: Int?,
                   recoveryShares: Int?,
                   recoveryThreshold: Int?,
                   recoveryPGPKeys: [String]?) {
            self.pgpKeys = pgpKeys
            self.rootTokenPGPKey = rootTokenPGPKey
            self.secretShares = secretShares
            self.secretThreshold = secretThreshold
            self.storedShares = storedShares
            self.recoveryShares = recoveryShares
            self.recoveryThreshold = recoveryThreshold
            self.recoveryPGPKeys = recoveryPGPKeys
        }

        enum CodingKeys: String, CodingKey {
            case pgpKeys = "pgp_keys"
            case rootTokenPGPKey = "root_token_pgp_key"
            case secretShares = "secret_shares"
            case secretThreshold = "secret_threshold"
            case storedShares = "stored_shares"
            case recoveryShares = "recovery_shares"
            case recoveryThreshold = "recovery_threshold"
            case recoveryPGPKeys = "recovery_pgp_keys"
        }
    }
}
