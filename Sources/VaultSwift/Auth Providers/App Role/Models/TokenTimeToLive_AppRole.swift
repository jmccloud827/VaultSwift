import Foundation

public extension Vault.AuthProviders.AppRoleClient {
    struct TokenTimeToLive: Decodable, Sendable {
        public let timeToLive: Int?

        enum CodingKeys: String, CodingKey {
            case timeToLive = "token_ttl"
        }
    }
}
