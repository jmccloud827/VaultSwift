import Foundation

public extension Vault.SecretEngines.DatabaseClient {
    struct ConnectionConfigResponse: Decodable, Sendable {
        public let pluginName: String?
        public let pluginVersion: String?
        public let allowedRoles: [String]?
        public let connectionDetails: ConnectionDetailsModel?
        public let passwordPolicyName: String?
        public let rootCredentialsRotateStatements: [String]?

        enum CodingKeys: String, CodingKey {
            case pluginName = "plugin_name"
            case pluginVersion = "plugin_version"
            case allowedRoles = "allowed_roles"
            case connectionDetails = "connection_details"
            case passwordPolicyName = "password_policy"
            case rootCredentialsRotateStatements = "root_credentials_rotate_statements"
        }
        
        public struct ConnectionDetailsModel: Decodable, Sendable {
            public let connectionUrl: String?
            public let username: String?

            enum CodingKeys: String, CodingKey {
                case connectionUrl = "connection_url"
                case username = "username"
            }
        }
    }
}
