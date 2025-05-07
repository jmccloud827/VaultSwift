import Foundation

public extension Vault.SystemBackend.MFAClient {
    struct PingIDClient: BaseClient {
        public let basePath = "pingid"
        public let client: Vault.Client
        
        public struct Config: Codable, Sendable {
            public let mountAccessor: String?
            public let id: String?
            public let usernameFormat: String?
            public let base64SettingsFile: String?
            public let useSignature: Bool?
            public let idpURL: String?
            public let adminURL: String?
            public let authenticatorURL: String?
            public let orgAlias: String?
            
            public init(mountAccessor: String?,
                        id: String?,
                        usernameFormat: String?,
                        base64SettingsFile: String?,
                        useSignature: Bool?,
                        idpURL: String?,
                        adminURL: String?,
                        authenticatorURL: String?,
                        orgAlias: String?) {
                self.mountAccessor = mountAccessor
                self.id = id
                self.usernameFormat = usernameFormat
                self.base64SettingsFile = base64SettingsFile
                self.useSignature = useSignature
                self.idpURL = idpURL
                self.adminURL = adminURL
                self.authenticatorURL = authenticatorURL
                self.orgAlias = orgAlias
            }

            enum CodingKeys: String, CodingKey {
                case mountAccessor = "mount_accessor"
                case id
                case usernameFormat = "username_format"
                case base64SettingsFile = "settings_file_base64"
                case useSignature = "use_signature"
                case idpURL = "idp_url"
                case adminURL = "admin_url"
                case authenticatorURL = "authenticator_url"
                case orgAlias = "org_alias"
            }
        }
    }
}
