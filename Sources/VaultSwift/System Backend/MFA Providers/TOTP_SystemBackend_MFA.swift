import Foundation

public extension Vault.SystemBackend.MFAClient {
    struct TOTPClient: BaseClient {
        public let basePath = "totp"
        public let client: Vault.Client
        
        public struct Config: Codable, Sendable {
            public let id: String?
            public let issuer: String?
            public let period: String?
            public let keySize: Int?
            public let qrSize: Int?
            public let algorithm: String?
            public let digits: Int?
            public let skew: Int?
            
            public init(id: String?,
                        issuer: String?,
                        period: String? = "30",
                        keySize: Int? = 20,
                        qrSize: Int? = 200,
                        algorithm: String? = "SHA1",
                        digits: Int? = 6,
                        skew: Int? = 1) {
                self.id = id
                self.issuer = issuer
                self.period = period
                self.keySize = keySize
                self.qrSize = qrSize
                self.algorithm = algorithm
                self.digits = digits
                self.skew = skew
            }

            enum CodingKeys: String, CodingKey {
                case id
                case issuer
                case period
                case keySize = "key_size"
                case qrSize = "qr_size"
                case algorithm
                case digits
                case skew
            }
        }
    }
}
