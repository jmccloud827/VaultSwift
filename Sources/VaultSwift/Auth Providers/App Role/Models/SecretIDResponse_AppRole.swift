import Foundation

public extension Vault.AuthProviders.AppRoleClient {
    struct SecretIDResponse: Decodable, Sendable {
        public let secretId: String?
        public let secretIdAccessor: String?
        public let secretIdNumberOfUses: Int?
        public let secretIdTimeToLive: Int?

        enum CodingKeys: String, CodingKey {
            case secretId = "secret_id"
            case secretIdAccessor = "secret_id_accessor"
            case secretIdNumberOfUses = "secret_id_num_uses"
            case secretIdTimeToLive = "secret_id_ttl"
        }
    }
}
