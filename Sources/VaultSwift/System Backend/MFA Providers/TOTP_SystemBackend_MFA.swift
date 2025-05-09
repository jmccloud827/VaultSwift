import Foundation

public extension Vault.SystemBackend.MFAClient {
    /// A client for interacting with TOTP MFA in a Vault instance.
    struct TOTPClient: BaseClient {
        public let basePath = "totp"
        public let client: Vault.Client
        
        /// A structure representing the configuration for TOTP MFA.
        public struct Config: Codable, Sendable {
            public let id: String?
            public let issuer: String?
            public let period: String?
            public let keySize: Int?
            public let qrSize: Int?
            public let algorithm: String?
            public let digits: Int?
            public let skew: Int?
            
            /// Initializes a new instance of `Config`.
            ///
            /// - Parameters:
            ///   - id: The identifier for the TOTP configuration.
            ///   - issuer: The issuer name for the TOTP configuration.
            ///   - period: The period for which a TOTP code is valid, in seconds. Default is "30".
            ///   - keySize: The size of the key used for TOTP, in bytes. Default is 20.
            ///   - qrSize: The size of the QR code generated for TOTP, in pixels. Default is 200.
            ///   - algorithm: The algorithm used for TOTP. Default is "SHA1".
            ///   - digits: The number of digits in the TOTP code. Default is 6.
            ///   - skew: The allowable skew (drift) between the client and server time, in periods. Default is 1.
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
