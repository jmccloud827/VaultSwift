import Foundation

public extension Vault.SSH {
    struct SignKeyRequest: Encodable, Sendable {
        public let publicKey: String?
        public let timeToLive: Int?
        public let validPrincipals: String?
        public let certificateType: String?
        public let keyID: String?
        public let criticalOptions: [String: String]?
        public let `extension`: [String: String]?
        
        public init(publicKey: String?, timeToLive: Int?, validPrincipals: String?, certificateType: String?, keyID: String?, criticalOptions: [String: String]?, extension: [String: String]?) {
            self.publicKey = publicKey
            self.timeToLive = timeToLive
            self.validPrincipals = validPrincipals
            self.certificateType = certificateType
            self.keyID = keyID
            self.criticalOptions = criticalOptions
            self.extension = `extension`
        }
        
        enum CodingKeys: String, CodingKey {
            case publicKey = "public_key"
            case timeToLive = "ttl"
            case validPrincipals = "valid_principals"
            case certificateType = "cert_type"
            case keyID = "key_id"
            case criticalOptions = "critical_options"
            case `extension`
        }
    }
}
