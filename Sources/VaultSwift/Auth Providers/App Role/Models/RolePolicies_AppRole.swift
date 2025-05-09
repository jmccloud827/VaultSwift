import Foundation

public extension Vault.AuthProviders.AppRoleClient {
    struct RolePolicies: Codable, Sendable {
        public let policies: [String]?
        public let tokenPolicies: [String]?

        enum CodingKeys: String, CodingKey {
            case policies
            case tokenPolicies = "token_policies"
        }
    }
}
