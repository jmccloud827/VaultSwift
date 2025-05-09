import Foundation

public extension Vault.SystemBackend.MFAClient {
    /// A client for interacting with Okta MFA in a Vault instance.
    struct OktaClient: BaseClient {
        public let basePath = "okta"
        public let client: Vault.Client
        
        /// A structure representing the configuration for Okta MFA.
        public struct Config: Codable, Sendable {
            public let mountAccessor: String?
            public let id: String?
            public let usernameFormat: String?
            public let orgName: String?
            public let apiToken: String?
            public let baseURL: String?
            public let production: Bool?
            
            /// Initializes a new `Config` instance.
            ///
            /// - Parameters:
            ///   - mountAccessor: The mount accessor.
            ///   - id: The ID.
            ///   - usernameFormat: The username format.
            ///   - orgName: The organization name.
            ///   - apiToken: The API token.
            ///   - baseURL: The base URL.
            ///   - production: Indicates whether it is a production environment.
            public init(mountAccessor: String?,
                        id: String?,
                        usernameFormat: String?,
                        orgName: String?,
                        apiToken: String?,
                        baseURL: String?,
                        production: Bool?) {
                self.mountAccessor = mountAccessor
                self.id = id
                self.usernameFormat = usernameFormat
                self.orgName = orgName
                self.apiToken = apiToken
                self.baseURL = baseURL
                self.production = production
            }

            enum CodingKeys: String, CodingKey {
                case mountAccessor = "mount_accessor"
                case id
                case usernameFormat = "username_format"
                case orgName = "org_name"
                case apiToken = "api_token"
                case baseURL = "base_url"
                case production
            }
        }
    }
}
