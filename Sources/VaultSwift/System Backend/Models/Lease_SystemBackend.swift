import Foundation

public extension Vault.SystemBackend {
    struct Lease: Decodable, Sendable {
        public let id: String?
        public let issueTime: Date?
        public let expiryTime: Date?
        public let lastRenewalTime: Date?
        public let renewable: Bool?
        public let timeToLive: Int?

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case issueTime = "issue_time"
            case expiryTime = "expire_time"
            case lastRenewalTime = "last_renewal_time"
            case renewable = "renewable"
            case timeToLive = "ttl"
        }
    }
}
