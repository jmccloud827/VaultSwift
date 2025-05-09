import Foundation

public extension Vault.SystemBackend.MFAClient {
    /// A client for interacting with PingID MFA in a Vault instance.
    struct PingIDClient: BaseClient {
        public let basePath = "pingid"
        public let client: Vault.Client
        
        /// A structure representing the configuration for PingID MFA.
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
            
            /// Initializes a new instance of `Config`.
            ///
            /// - Parameters:
            ///   - mountAccessor: The accessor for the mount point.
            ///   - id: The identifier for the PingID configuration.
            ///   - usernameFormat: The format for the username.
            ///   - base64SettingsFile: The settings file encoded in base64 format.
            ///   - useSignature: A boolean indicating whether to use a signature.
            ///   - idpURL: The URL for the identity provider (IDP).
            ///   - adminURL: The URL for the admin interface.
            ///   - authenticatorURL: The URL for the authenticator.
            ///   - orgAlias: The alias for the organization.
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
