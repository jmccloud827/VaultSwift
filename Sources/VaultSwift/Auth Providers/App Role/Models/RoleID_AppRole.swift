import Foundation

public extension Vault.AuthProviders.AppRoleClient {
    struct RoleID: Codable, Sendable {
        public let roleId: String?

        enum CodingKeys: String, CodingKey {
            case roleId = "role_id"
        }
    }
}
