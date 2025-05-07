import Foundation

public extension Vault.SecretEngines.TOTPClient {
    struct CreateKeyRequestVault: Encodable, Sendable {
        public let generate: Bool = true
        public let exported: Bool?
        public let keySize: Int?
        public let skew: Int?
        public let qrSize: Int?
        public let issuer: String?
        public let accountName: String?
        public let period: String?
        public let algorithm: String?
        public let digits: Int?
        
        public init(exported: Bool?,
                    keySize: Int?,
                    skew: Int?,
                    qrSize: Int?,
                    issuer: String?,
                    accountName: String?,
                    period: String?,
                    algorithm: String?,
                    digits: Int?) {
            self.exported = exported
            self.keySize = keySize
            self.skew = skew
            self.qrSize = qrSize
            self.issuer = issuer
            self.accountName = accountName
            self.period = period
            self.algorithm = algorithm
            self.digits = digits
        }
        
        enum CodingKeys: String, CodingKey {
            case generate
            case exported
            case keySize = "key_size"
            case qrSize = "qr_size"
            case issuer
            case accountName = "account_name"
            case period
            case algorithm
        }
    }
}
