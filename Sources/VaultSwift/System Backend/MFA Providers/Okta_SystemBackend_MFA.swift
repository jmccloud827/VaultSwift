import Foundation

public extension Vault.SystemBackend.MFAClient {
    struct OktaClient: BaseClient {
        public let basePath = "okta"
        public let client: Vault.Client
        
        public struct Config: Codable, Sendable {
            public let mountAccessor: String?
            public let id: String?
            public let usernameFormat: String?
            public let orgName: String?
            public let apiToken: String?
            public let baseURL: String?
            public let production: Bool?
            
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
