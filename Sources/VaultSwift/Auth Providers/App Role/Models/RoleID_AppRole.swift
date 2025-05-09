import Foundation

public extension Vault.AuthProviders.AppRoleClient {
    struct RoleID: Codable, Sendable {
        public let roleID: String?

        enum CodingKeys: String, CodingKey {
            case roleID = "role_id"
        }
    }
}
