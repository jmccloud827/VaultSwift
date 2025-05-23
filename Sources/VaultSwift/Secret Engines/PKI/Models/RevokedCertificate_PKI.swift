import Foundation

public extension Vault.SecretEngines.PKIClient {
    struct RevokedCertificate: Decodable, Sendable {
        public let revocationTime: Int?
        public let revocationTimeRFC3339: String?
        public let revocationIssuerID: String?
        
        enum CodingKeys: String, CodingKey {
            case revocationTime = "revocation_time"
            case revocationTimeRFC3339 = "revocation_time_rfc3339"
            case revocationIssuerID = "issuer_id"
        }
    }
}
