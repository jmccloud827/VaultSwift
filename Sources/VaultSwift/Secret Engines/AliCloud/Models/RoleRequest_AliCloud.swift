import Foundation

public extension Vault.AliCloud {
    struct RoleRequest: Encodable, Sendable {
        public let remotePoliciesJson: String?
        public let inlinePoliciesJson: String?
        public let roleARN: String?
        public let timeToLive: Int?
        public let maximumTimeToLive: Int?
        
        public init(remotePoliciesJson: String?,
                    inlinePoliciesJson: String?,
                    roleARN: String?,
                    timeToLive: Int?,
                    maximumTimeToLive: Int?) {
            self.remotePoliciesJson = remotePoliciesJson
            self.inlinePoliciesJson = inlinePoliciesJson
            self.roleARN = roleARN
            self.timeToLive = timeToLive
            self.maximumTimeToLive = maximumTimeToLive
        }
        
        enum CodingKeys: String, CodingKey {
            case remotePoliciesJson = "remote_policies"
            case inlinePoliciesJson = "inline_policies"
            case roleARN = "role_arn"
            case timeToLive = "ttl"
            case maximumTimeToLive = "max_ttl"
        }
    }
}
