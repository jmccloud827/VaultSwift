import Foundation

public extension Vault.AuthProviders.AppRoleClient {
    struct SecretIDRequest: Encodable, Sendable {
        public let metadata: String?
        public let cidrList: [String]?
        public let tokenBoundCIDRs: [String]?
        public let numberOfUses: Int?
        public let timeToLive: Int?
        
        public init(metadata: String?, cidrList: [String]?, tokenBoundCIDRs: [String]?, numberOfUses: Int?, timeToLive: Int?) {
            self.metadata = metadata
            self.cidrList = cidrList
            self.tokenBoundCIDRs = tokenBoundCIDRs
            self.numberOfUses = numberOfUses
            self.timeToLive = timeToLive
        }

        enum CodingKeys: String, CodingKey {
            case metadata
            case cidrList = "cidr_list"
            case tokenBoundCIDRs = "token_bound_cidrs"
            case numberOfUses = "num_uses"
            case timeToLive = "ttl"
        }
    }
}
