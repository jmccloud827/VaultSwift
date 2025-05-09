import Foundation

public struct VaultResponse<T: Decodable & Sendable>: Decodable {
    public let requestID: String
    public let leaseID: String
    public let renewable: Bool
    public let leaseDuration: Int
    public let data: T
    public let wrapInfo: WrapInfo?
    public let warnings: [String]?
    public let auth: Auth?
    public let mountType: String
    
    enum CodingKeys: String, CodingKey {
        case requestID = "request_id"
        case leaseID = "lease_id"
        case renewable
        case leaseDuration = "lease_duration"
        case data
        case wrapInfo = "wrap_info"
        case warnings
        case auth
        case mountType = "mount_type"
    }
    
    public struct WrapInfo: Decodable, Sendable {
        public let token: String
        public let timeToLive: Int
        public let creationTime: String
        public let accessor: String
        public let creationPath: String
        
        enum CodingKeys: String, CodingKey {
            case token
            case timeToLive = "ttl"
            case creationTime = "creation_time"
            case accessor
            case creationPath = "creation_path"
        }
    }
    
    public struct Auth: Decodable, Sendable {
        public let clientToken: String
        public let accessor: String
        public let policies: [String]
        public let tokenPolicies: [String]
        public let identityPolicies: [String]
        public let metadata: [String: String]
        public let leaseDuration: Int
        public let renewable: Bool
        public let entityID: String
        public let tokenType: String
        public let orphan: Bool
        public let numberOfUses: Int
        
        enum CodingKeys: String, CodingKey {
            case clientToken = "client_token"
            case accessor
            case policies
            case tokenPolicies = "token_policies"
            case identityPolicies = "identity_policies"
            case metadata
            case leaseDuration = "lease_duration"
            case renewable
            case entityID = "entity_id"
            case tokenType = "token_type"
            case orphan
            case numberOfUses = "num_uses"
        }
    }
}
