import Foundation

public extension Vault.Consul {
    struct Role: Codable, Sendable {
        public let consulNamespace: String?
        public let base64EncodedACLConsulPolicies: [String]?
        public let consulRoles: [String]?
        @available(*, deprecated) public let lease: Int?
        public let local: Bool?
        public let maximumTimeToLive: Int?
        public let nodeIdentities: [String]?
        public let consulAdminPartition: String?
        public let serviceIdentities: [String]?
        public let timeToLive: Int?
        @available(*, deprecated) public let consulTokenType: TokenType?
        @available(*, deprecated) public let base64EncodedACLPolicy: String?
        @available(*, deprecated) public let base64EncodedACLPolicies: [String]?
        
        public init(consulNamespace: String?,
                    base64EncodedACLConsulPolicies: [String]?,
                    consulRoles: [String]?,
                    local: Bool?,
                    maximumTimeToLive: Int?,
                    nodeIdentities: [String]?,
                    consulAdminPartition: String?,
                    serviceIdentities: [String]?,
                    timeToLive: Int?) {
            self.consulNamespace = consulNamespace
            self.base64EncodedACLConsulPolicies = base64EncodedACLConsulPolicies
            self.consulRoles = consulRoles
            self.lease = nil
            self.local = local
            self.maximumTimeToLive = maximumTimeToLive
            self.nodeIdentities = nodeIdentities
            self.consulAdminPartition = consulAdminPartition
            self.serviceIdentities = serviceIdentities
            self.timeToLive = timeToLive
            self.consulTokenType = nil
            self.base64EncodedACLPolicy = nil
            self.base64EncodedACLPolicies = nil
        }
        
        @available(*, deprecated)
        public init(consulNamespace: String?,
                    base64EncodedACLConsulPolicies: [String]?,
                    consulRoles: [String]?,
                    lease: Int?,
                    local: Bool?,
                    maximumTimeToLive: Int?,
                    nodeIdentities: [String]?,
                    consulAdminPartition: String?,
                    serviceIdentities: [String]?,
                    timeToLive: Int?,
                    consulTokenType: TokenType?,
                    base64EncodedACLPolicy: String?,
                    base64EncodedACLPolicies: [String]?) {
            self.consulNamespace = consulNamespace
            self.base64EncodedACLConsulPolicies = base64EncodedACLConsulPolicies
            self.consulRoles = consulRoles
            self.lease = lease
            self.local = local
            self.maximumTimeToLive = maximumTimeToLive
            self.nodeIdentities = nodeIdentities
            self.consulAdminPartition = consulAdminPartition
            self.serviceIdentities = serviceIdentities
            self.timeToLive = timeToLive
            self.consulTokenType = consulTokenType
            self.base64EncodedACLPolicy = base64EncodedACLPolicy
            self.base64EncodedACLPolicies = base64EncodedACLPolicies
        }
        
        enum CodingKeys: String, CodingKey {
            case consulNamespace = "consul_namespace"
            case base64EncodedACLConsulPolicies = "consul_policies"
            case consulRoles = "consul_roles"
            case lease = "lease"
            case local = "local"
            case maximumTimeToLive = "max_ttl"
            case nodeIdentities = "node_identities"
            case consulAdminPartition = "partition"
            case serviceIdentities = "service_identities"
            case timeToLive = "ttl"
            case consulTokenType = "token_type"
            case base64EncodedACLPolicy = "policy"
            case base64EncodedACLPolicies = "policies"
        }
    }
    
    enum TokenType: String, Codable, Sendable {
        case client
        case management
    }
}
