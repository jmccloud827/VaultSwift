import Foundation

public extension Vault.AuthProviders.TokenClient {
    struct TokenRoleResponse: Decodable, Sendable {
        public let name: String?
        public let orphan: Bool?
        public let pathSuffix: String?
        public let period: String?
        public let renewable: Bool?
        public let tokenExplicitMaxTimeToLive: String?
        public let tokenNoDefaultPolicy: Bool?
        public let tokenPeriod: String?
        public let tokenType: String?
        public let explicitMaxTimeToLive: String?
        public let allowedEntityAliases: [String]?
        public let allowedPolcies: [String]?
        public let disallowedPolcies: [String]?
        public let allowedPolciesGlob: [String]?
        public let disallowedPolciesGlob: [String]?

        enum CodingKeys: String, CodingKey {
            case name
            case orphan
            case pathSuffix = "path_suffix"
            case period
            case renewable
            case tokenExplicitMaxTimeToLive = "token_explicit_max_ttl"
            case tokenNoDefaultPolicy = "token_no_default_policy"
            case tokenPeriod = "token_period"
            case tokenType = "token_type"
            case explicitMaxTimeToLive = "explicit_max_ttl"
            case allowedEntityAliases = "allowed_entity_aliases"
            case allowedPolcies = "allowed_policies"
            case disallowedPolcies = "disallowed_policies"
            case allowedPolciesGlob = "allowed_policies_glob"
            case disallowedPolciesGlob = "disallowed_policies_glob"
        }
    }
}
