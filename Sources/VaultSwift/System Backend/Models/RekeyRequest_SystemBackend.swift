import Foundation

public extension Vault.SystemBackend {
    struct RekeyRequest: Encodable, Sendable {
        public let secretShares: Int?
        public let secretThreshold: Int?
        public let pgpKeys: [String]?
        public let backup: Bool
        
        /// Initializes a new `RekeyRequest` instance.
        ///
        /// - Parameters:
        ///   - secretShares: The number of shares to split the master key into
        ///   - secretThreshold: The number of shares required to reconstruct the master key. This must be less than or equal to secretShares.
        ///   - pgpKeys: An array of PGP public keys used to encrypt the output unseal keys. Ordering is preserved. The keys must be base64-encoded from their original binary representation. The size of this array must be the same as secretShares.
        ///   - backup: If using PGP-encrypted keys, whether Vault should also back them up to a well-known location in physical storage. These can then be retrieved and removed via the GetRekeyBackupAsync endpoint. Makes sense only when pgp keys are provided. Defaults to 'false', meaning no backup.
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
