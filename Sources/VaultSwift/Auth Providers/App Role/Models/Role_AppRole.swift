import Foundation

public extension Vault.AuthProviders.AppRoleClient {
    struct Role: Codable, Sendable {
        public let bindSecretID: Bool?
        public let localSecretIDs: Bool?
        public let policies: [String]?
        public let secretIDBoundCIDRs: [String]?
        public let secretIDNumberOfUses: Int?
        public let secretIDTimeToLive: Int?
        public let tokenBoundCIDRs: [String]?
        public let tokenExplicitMaximumTimeToLive: Int?
        public let tokenMaximumTimeToLive: Int?
        public let tokenNoDefaultPolicy: Bool?
        public let tokenNumberOfUses: Int?
        public let tokenPeriod: Int?
        public let tokenPolicies: [String]?
        public let tokenTimeToLive: Int?
        public let tokenType: AuthTokenType?
        
        public init(bindSecretID: Bool?,
                    localSecretIDs: Bool?,
                    policies: [String]?,
                    secretIDBoundCIDRs: [String]?,
                    secretIDNumberOfUses: Int?,
                    secretIDTimeToLive: Int?,
                    tokenBoundCIDRs: [String]?,
                    tokenExplicitMaximumTimeToLive: Int?,
                    tokenMaximumTimeToLive: Int?,
                    tokenNoDefaultPolicy: Bool?,
                    tokenNumberOfUses: Int?,
                    tokenPeriod: Int?,
                    tokenPolicies: [String]?,
                    tokenTimeToLive: Int?,
                    tokenType: AuthTokenType?) {
            self.bindSecretID = bindSecretID
            self.localSecretIDs = localSecretIDs
            self.policies = policies
            self.secretIDBoundCIDRs = secretIDBoundCIDRs
            self.secretIDNumberOfUses = secretIDNumberOfUses
            self.secretIDTimeToLive = secretIDTimeToLive
            self.tokenBoundCIDRs = tokenBoundCIDRs
            self.tokenExplicitMaximumTimeToLive = tokenExplicitMaximumTimeToLive
            self.tokenMaximumTimeToLive = tokenMaximumTimeToLive
            self.tokenNoDefaultPolicy = tokenNoDefaultPolicy
            self.tokenNumberOfUses = tokenNumberOfUses
            self.tokenPeriod = tokenPeriod
            self.tokenPolicies = tokenPolicies
            self.tokenTimeToLive = tokenTimeToLive
            self.tokenType = tokenType
        }

        enum CodingKeys: String, CodingKey {
            case bindSecretID = "bind_secret_id"
            case localSecretIDs = "local_secret_ids"
            case policies
            case secretIDBoundCIDRs = "secret_id_bound_cidrs"
            case secretIDNumberOfUses = "secret_id_num_uses"
            case secretIDTimeToLive = "secret_id_ttl"
            case tokenBoundCIDRs = "token_bound_cidrs"
            case tokenExplicitMaximumTimeToLive = "token_explicit_max_ttl"
            case tokenMaximumTimeToLive = "token_max_ttl"
            case tokenNoDefaultPolicy = "token_no_default_policy"
            case tokenNumberOfUses = "token_num_uses"
            case tokenPeriod = "token_period"
            case tokenPolicies = "token_policies"
            case tokenTimeToLive = "token_ttl"
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
