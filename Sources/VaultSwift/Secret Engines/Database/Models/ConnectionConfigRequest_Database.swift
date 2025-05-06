import Foundation

public extension Vault.Database {
    struct ConnectionConfigRequest: Encodable, Sendable {
        public let pluginName: String?
        public let pluginVersion: String?
        public let verifyConnection: Bool?
        public let allowedRoles: [String]?
        public let rootRotationStatements: [String]?
        public let passwordPolicyName: String?
        public let connectionURL: String?
        public let username: String?
        public let password: String?
        public let disableEscapingSpecialCharactersInUsernameAndPassword: Bool?
        
        public init(pluginName: String?,
                    pluginVersion: String?,
                    verifyConnection: Bool? = true,
                    allowedRoles: [String]?,
                    rootRotationStatements: [String]?,
                    passwordPolicyName: String?,
                    connectionURL: String?,
                    username: String?,
                    password: String?,
                    disableEscapingSpecialCharactersInUsernameAndPassword: Bool? = false) {
            self.pluginName = pluginName
            self.pluginVersion = pluginVersion
            self.verifyConnection = verifyConnection
            self.allowedRoles = allowedRoles
            self.rootRotationStatements = rootRotationStatements
            self.passwordPolicyName = passwordPolicyName
            self.connectionURL = connectionURL
            self.username = username
            self.password = password
            self.disableEscapingSpecialCharactersInUsernameAndPassword = disableEscapingSpecialCharactersInUsernameAndPassword
        }

        enum CodingKeys: String, CodingKey {
            case pluginName = "plugin_name"
            case pluginVersion = "plugin_version"
            case verifyConnection = "verify_connection"
            case allowedRoles = "allowed_roles"
            case rootRotationStatements = "root_rotation_statements"
            case passwordPolicyName = "password_policy"
            case connectionURL = "connection_url"
            case username
            case password
            case disableEscapingSpecialCharactersInUsernameAndPassword = "disable_escaping"
        }
    }
}
