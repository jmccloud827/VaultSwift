import Foundation

public extension Vault.AuthProviders.AppRoleClient {
    struct SecretIDUsage: Decodable, Sendable {
        public let numberOfUses: Int?

        enum CodingKeys: String, CodingKey {
            case numberOfUses = "secret_id_num_uses"
        }
    }
}
