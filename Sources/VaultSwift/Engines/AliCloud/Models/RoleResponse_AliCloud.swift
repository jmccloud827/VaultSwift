import Foundation

public extension Vault.AliCloud {
    struct RoleResponse: Decodable, Sendable {
        public let remotePoliciesJson: String?
        public let inlinePoliciesJson: String?
        public let roleARN: String?
        public let timeToLive: Int?
        
        enum CodingKeys: String, CodingKey {
            case remotePoliciesJson = "remote_policies"
            case inlinePoliciesJson = "inline_policies"
            case roleARN = "role_arn"
            case timeToLive = "ttl"
        }
    }
}
