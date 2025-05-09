import Foundation

public extension Vault.AuthProviders.AppRoleClient {
    struct SecretIDResponse: Decodable, Sendable {
        public let secretID: String?
        public let secretIDAccessor: String?
        public let secretIDNumberOfUses: Int?
        public let secretIDTimeToLive: Int?

        enum CodingKeys: String, CodingKey {
            case secretID = "secret_id"
            case secretIDAccessor = "secret_id_accessor"
            case secretIDNumberOfUses = "secret_id_num_uses"
            case secretIDTimeToLive = "secret_id_ttl"
        }
    }
}
