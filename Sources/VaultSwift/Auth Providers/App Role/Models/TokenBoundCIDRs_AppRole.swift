import Foundation

public extension Vault.AuthProviders.AppRoleClient {
    struct TokenBoundCIDRs: Decodable, Sendable {
        public let tokenBoundCIDRs: [String]?

        enum CodingKeys: String, CodingKey {
            case tokenBoundCIDRs = "token_bound_cidrs"
        }
    }
}
