import Foundation

public extension Vault.TOTP {
    struct CreateKeyRequest: Encodable, Sendable {
        public let url: String?
        public let key: String?
        public let issuer: String?
        public let accountName: String?
        public let period: String?
        public let algorithm: String?
        public let digits: Int?
        
        public init(url: String?, key: String?, issuer: String?, accountName: String?, period: String?, algorithm: String?, digits: Int?) {
            self.url = url
            self.key = key
            self.issuer = issuer
            self.accountName = accountName
            self.period = period
            self.algorithm = algorithm
            self.digits = digits
        }
        
        enum CodingKeys: String, CodingKey {
            case url
            case key
            case issuer
            case accountName = "account_name"
            case period
            case algorithm
        }
    }
}
