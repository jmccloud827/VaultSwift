import Foundation

public extension Vault.AuthProviders.AppRoleClient {
    struct SecretIDBinding: Decodable, Sendable {
        public let bound: Bool?

        enum CodingKeys: String, CodingKey {
            case bound = "bind_secret_id"
        }
    }
}
