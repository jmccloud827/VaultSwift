import Foundation

public extension Vault.AuthProviders.AppRoleClient {
    struct SecretIDInfo: Decodable, Sendable {
        public let cidrList: [String]?
        public let creationTime: String?
        public let expirationTime: String?
        public let lastUpdatedTime: String?
        public let metadata: [String: String]?
        public let secretIdAccessor: String?
        public let secretIdNumberOfUses: Int?
        public let secretIdTimeToLive: Int?
        public let tokenBoundCIDRs: [String]?

        enum CodingKeys: String, CodingKey {
            case cidrList = "cidr_list"
            case creationTime = "creation_time"
            case expirationTime = "expiration_time"
            case lastUpdatedTime = "last_updated_time"
            case metadata = "metadata"
            case secretIdAccessor = "secret_id_accessor"
            case secretIdNumberOfUses = "secret_id_num_uses"
            case secretIdTimeToLive = "secret_id_ttl"
            case tokenBoundCIDRs = "token_bound_cidrs"
        }
    }
}
