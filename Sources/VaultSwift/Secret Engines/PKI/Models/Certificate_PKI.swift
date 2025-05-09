import Foundation

public extension Vault.SecretEngines.PKIClient {
    struct Certificate: Decodable, Sendable {
        public let certificateContent: String?
        public let revocationTime: Int?
        public let revocationTimeRFC3339: String?
        public let revocationIssuerId: String?
        
        enum CodingKeys: String, CodingKey {
            case certificateContent = "certificate"
            case revocationTime = "revocation_time"
            case revocationTimeRFC3339 = "revocation_time_rfc3339"
            case revocationIssuerId = "issuer_id"
        }
    }
}
