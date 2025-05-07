import Foundation

public extension Vault.SystemBackend.MFAClient {
    struct DuoClient: BaseClient {
        public let basePath = "duo"
        public let client: Vault.Client
        
        public struct Config: Codable, Sendable {
            public let mountAccessor: String?
            public let id: String?
            public let usernameFormat: String?
            public let secretKey: String?
            public let integrationKey: String?
            public let apiHostname: String?
            public let pushInfo: String?
            
            public init(mountAccessor: String?,
                        id: String?,
                        usernameFormat: String?,
                        secretKey: String?,
                        integrationKey: String?,
                        apiHostname: String?,
                        pushInfo: String?) {
                self.mountAccessor = mountAccessor
                self.id = id
                self.usernameFormat = usernameFormat
                self.secretKey = secretKey
                self.integrationKey = integrationKey
                self.apiHostname = apiHostname
                self.pushInfo = pushInfo
            }

            enum CodingKeys: String, CodingKey {
                case mountAccessor = "mount_accessor"
                case id
                case usernameFormat = "username_format"
                case secretKey = "secret_key"
                case integrationKey = "integration_key"
                case apiHostname = "api_hostname"
                case pushInfo = "push_info"
            }
        }
    }
}
