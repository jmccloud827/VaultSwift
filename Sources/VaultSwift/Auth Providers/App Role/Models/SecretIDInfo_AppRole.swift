import Foundation

public extension Vault.AuthProviders.AppRoleClient {
    struct SecretIDInfo: Decodable, Sendable {
        public let cidrList: [String]?
        public let creationTime: String?
        public let expirationTime: String?
        public let lastUpdatedTime: String?
        public let metadata: [String: String]?
        public let secretIDAccessor: String?
        public let secretIDNumberOfUses: Int?
        public let secretIDTimeToLive: Int?
        public let tokenBoundCIDRs: [String]?

        enum CodingKeys: String, CodingKey {
            case cidrList = "cidr_list"
            case creationTime = "creation_time"
            case expirationTime = "expiration_time"
            case lastUpdatedTime = "last_updated_time"
            case metadata
            case secretIDAccessor = "secret_id_accessor"
            case secretIDNumberOfUses = "secret_id_num_uses"
            case secretIDTimeToLive = "secret_id_ttl"
            case tokenBoundCIDRs = "token_bound_cidrs"
        }
    }
}
