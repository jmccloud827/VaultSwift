import Foundation

public extension Vault.AuthProviders.TokenClient {
    struct TokenRequest: Encodable, Sendable {
        public let id: String?
        public let roleName: String?
        public let policies: [String]?
        public let metadata: [String: String]?
        public let noParent: Bool?
        public let createOrphan: Bool?
        public let noDefaultPolicy: Bool?
        public let renewable: Bool?
        public let timeToLive: Int?
        public let tokenType: String?
        public let explicitMaxTimeToLive: String?
        public let displayName: String?
        public let numberOfUses: Int?
        public let period: String?
        public let entityAlias: String?
        
        public init(id: String?,
                    roleName: String?,
                    policies: [String]?,
                    metadata: [String: String]?,
                    noParent: Bool?,
                    createOrphan: Bool?,
                    noDefaultPolicy: Bool?,
                    renewable: Bool? = false,
                    timeToLive: Int?,
                    tokenType: String?,
                    explicitMaxTimeToLive: String?,
                    displayName: String?,
                    numberOfUses: Int?,
                    period: String?,
                    entityAlias: String?) {
            self.id = id
            self.roleName = roleName
            self.policies = policies
            self.metadata = metadata
            self.noParent = noParent
            self.createOrphan = createOrphan
            self.noDefaultPolicy = noDefaultPolicy
            self.renewable = renewable
            self.timeToLive = timeToLive
            self.tokenType = tokenType
            self.explicitMaxTimeToLive = explicitMaxTimeToLive
            self.displayName = displayName
            self.numberOfUses = numberOfUses
            self.period = period
            self.entityAlias = entityAlias
        }

        enum CodingKeys: String, CodingKey {
            case id
            case roleName = "role_name"
            case policies
            case metadata = "meta"
            case noParent = "no_parent"
            case createOrphan
            case noDefaultPolicy = "no_default_policy"
            case renewable
            case timeToLive = "ttl"
            case tokenType = "type"
            case explicitMaxTimeToLive = "explicit_max_ttl"
            case displayName = "display_name"
            case numberOfUses = "num_uses"
            case period
            case entityAlias = "entity_alias"
        }
    }
}
