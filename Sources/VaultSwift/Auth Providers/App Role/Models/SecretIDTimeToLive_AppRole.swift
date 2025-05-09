import Foundation

public extension Vault.AuthProviders.AppRoleClient {
    struct SecretIDTimeToLive: Decodable, Sendable {
        public let timeToLive: Int?

        enum CodingKeys: String, CodingKey {
            case timeToLive = "secret_id_ttl"
        }
    }
}
