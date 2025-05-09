import Foundation

public extension Vault.AuthProviders.AppRoleClient {
    struct RolePeriod: Decodable, Sendable {
        public let tokenPeriod: Int?

        enum CodingKeys: String, CodingKey {
            case tokenPeriod = "token_period"
        }
    }
}
