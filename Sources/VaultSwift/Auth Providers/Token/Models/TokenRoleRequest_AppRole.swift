import Foundation

public extension Vault.AuthProviders.TokenClient {
    struct TokenRoleRequest: Encodable, Sendable {
        public let roleName: String?
        public let orphan: Bool?
        public let pathSuffix: String?
        public let renewable: Bool?
        public let tokenExplicitMaxTimeToLive: String?
        public let tokenNoDefaultPolicy: Bool?
        public let tokenPeriod: String?
        public let tokenType: String?
        public let allowedEntityAliases: [String]?
        public let allowedPolcies: [String]?
        public let disallowedPolcies: [String]?
        public let allowedPolciesGlob: [String]?
        public let disallowedPolciesGlob: [String]?
        public let tokenBoundCidrs: [String]?
        public let tokenNumUses: Int?
        
        public init(roleName: String?,
                    orphan: Bool?,
                    pathSuffix: String?,
                    renewable: Bool? = true,
                    tokenExplicitMaxTimeToLive: String?,
                    tokenNoDefaultPolicy: Bool?,
                    tokenPeriod: String?,
                    tokenType: String? = "service",
                    allowedEntityAliases: [String]?,
                    allowedPolcies: [String]?,
                    disallowedPolcies: [String]?,
                    allowedPolciesGlob: [String]?,
                    disallowedPolciesGlob: [String]?,
                    tokenBoundCidrs: [String]?,
                    tokenNumUses: Int?) {
            self.roleName = roleName
            self.orphan = orphan
            self.pathSuffix = pathSuffix
            self.renewable = renewable
            self.tokenExplicitMaxTimeToLive = tokenExplicitMaxTimeToLive
            self.tokenNoDefaultPolicy = tokenNoDefaultPolicy
            self.tokenPeriod = tokenPeriod
            self.tokenType = tokenType
            self.allowedEntityAliases = allowedEntityAliases
            self.allowedPolcies = allowedPolcies
            self.disallowedPolcies = disallowedPolcies
            self.allowedPolciesGlob = allowedPolciesGlob
            self.disallowedPolciesGlob = disallowedPolciesGlob
            self.tokenBoundCidrs = tokenBoundCidrs
            self.tokenNumUses = tokenNumUses
        }

        enum CodingKeys: String, CodingKey {
            case roleName = "role_name"
            case orphan
            case pathSuffix = "path_suffix"
            case renewable
            case tokenExplicitMaxTimeToLive = "token_explicit_max_ttl"
            case tokenNoDefaultPolicy = "token_no_default_policy"
            case tokenPeriod = "token_period"
            case tokenType = "token_type"
            case allowedEntityAliases = "allowed_entity_aliases"
            case allowedPolcies = "allowed_policies"
            case disallowedPolcies = "disallowed_policies"
            case allowedPolciesGlob = "allowed_policies_glob"
            case disallowedPolciesGlob = "disallowed_policies_glob"
            case tokenBoundCidrs = "token_bound_cidrs"
            case tokenNumUses = "token_num_uses"
        }
    }
}
