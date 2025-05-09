import Foundation

public extension Vault.AuthProviders.AppRoleClient {
    struct TokenMaxTimeToLive: Decodable, Sendable {
        public let maxTimeToLive: Int?

        enum CodingKeys: String, CodingKey {
            case maxTimeToLive = "token_max_ttl"
        }
    }
}
