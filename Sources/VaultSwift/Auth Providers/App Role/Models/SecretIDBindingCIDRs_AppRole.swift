import Foundation

public extension Vault.AuthProviders.AppRoleClient {
    struct SecretIDBindingCIDRs: Decodable, Sendable {
        public let boundCIDRs: [String]?

        enum CodingKeys: String, CodingKey {
            case boundCIDRs = "secret_id_bound_cidrs"
        }
    }
}
