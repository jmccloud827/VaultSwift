import Foundation

public extension Vault.AliCloud {
    struct RootCredentialsConfig: Codable, Sendable {
        public let accessKey: String
        public let secretKey: String?
        
        public init(accessKey: String) {
            self.accessKey = accessKey
            self.secretKey = nil
        }
        
        enum CodingKeys: String, CodingKey {
            case accessKey = "access_key"
            case secretKey = "secret_key"
        }
    }
}
