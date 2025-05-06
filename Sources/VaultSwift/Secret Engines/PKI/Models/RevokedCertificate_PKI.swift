import Foundation

public extension Vault.PKI {
    struct RevokedCertificate: Decodable, Sendable {
        public let revocationTime: Int?
        public let revocationTimeRFC3339: Date?
        public let revocationIssuerId: String?
        
        enum CodingKeys: String, CodingKey {
            case revocationTime = "revocation_time"
            case revocationTimeRFC3339 = "revocation_time_rfc3339"
            case revocationIssuerId = "issuer_id"
        }
    }
}
