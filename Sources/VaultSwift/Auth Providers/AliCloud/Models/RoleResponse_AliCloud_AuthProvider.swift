import Foundation

public extension Vault.AuthProviders.AliCloudClient {
    struct RoleResponse: Decodable, Sendable {
        public let arn: String?
        public let policies: [String]?
        public let timeToLive: Int?
        public let maximumTimeToLive: String?
        public let period: String?

        enum CodingKeys: String, CodingKey {
            case arn = "arn"
            case policies = "policies"
            case timeToLive = "ttl"
            case maximumTimeToLive = "max_ttl"
            case period = "period"
        }
    }
}
