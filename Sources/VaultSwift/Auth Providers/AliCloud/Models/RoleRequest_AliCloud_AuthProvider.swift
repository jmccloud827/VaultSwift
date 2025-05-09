import Foundation

public extension Vault.AuthProviders.AliCloudClient {
    struct RoleRequest: Encodable, Sendable {
        public let arn: String?
        public let tokenTimeToLive: String?
        public let tokenMaximumTimeToLive: String?
        public let tokenPolicies: [String]?
        public let policies: [String]?
        public let tokenBoundCIDRs: [String]?
        public let tokenExplicitMaximumTimeToLive: String?
        public let tokenNoDefaultPolicy: Bool?
        public let tokenNumberOfUses: Int?
        public let tokenPeriod: String?
        public let tokenType: AuthTokenType?
        
        public init(arn: String?,
                    tokenTimeToLive: String?,
                    tokenMaximumTimeToLive: String?,
                    tokenPolicies: [String]?,
                    policies: [String]?,
                    tokenBoundCIDRs: [String]?,
                    tokenExplicitMaximumTimeToLive: String?,
                    tokenNoDefaultPolicy: Bool?,
                    tokenNumberOfUses: Int?,
                    tokenPeriod: String?,
                    tokenType: AuthTokenType?) {
            self.arn = arn
            self.tokenTimeToLive = tokenTimeToLive
            self.tokenMaximumTimeToLive = tokenMaximumTimeToLive
            self.tokenPolicies = tokenPolicies
            self.policies = policies
            self.tokenBoundCIDRs = tokenBoundCIDRs
            self.tokenExplicitMaximumTimeToLive = tokenExplicitMaximumTimeToLive
            self.tokenNoDefaultPolicy = tokenNoDefaultPolicy
            self.tokenNumberOfUses = tokenNumberOfUses
            self.tokenPeriod = tokenPeriod
            self.tokenType = tokenType
        }

        enum CodingKeys: String, CodingKey {
            case arn
            case tokenTimeToLive = "token_ttl"
            case tokenMaximumTimeToLive = "token_max_ttl"
            case tokenPolicies = "token_policies"
            case policies
            case tokenBoundCIDRs = "token_bound_cidrs"
            case tokenExplicitMaximumTimeToLive = "token_explicit_max_ttl"
            case tokenNoDefaultPolicy = "token_no_default_policy"
            case tokenNumberOfUses = "token_num_uses"
            case tokenPeriod = "token_period"
            case tokenType = "token_type"
        }
        
        public enum AuthTokenType: String, Codable, Sendable {
            case service
            case batch
            case `default`
            case defaultService = "default-service"
            case defaultBatch = "default-batch"
        }
    }
}
