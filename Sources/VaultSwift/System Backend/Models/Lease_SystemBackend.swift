import Foundation

public extension Vault.SystemBackend {
    struct Lease: Decodable, Sendable {
        public let id: String?
        public let issueTime: String?
        public let expiryTime: String?
        public let lastRenewalTime: String?
        public let renewable: Bool?
        public let timeToLive: Int?

        enum CodingKeys: String, CodingKey {
            case id
            case issueTime = "issue_time"
            case expiryTime = "expire_time"
            case lastRenewalTime = "last_renewal_time"
            case renewable
            case timeToLive = "ttl"
        }
    }
}
