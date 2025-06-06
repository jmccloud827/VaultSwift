import Foundation

public extension Vault.SecretEngines.AliCloudClient {
    struct Credentials: Decodable, Sendable {
        public let accessKey: String?
        public let expiration: String?
        public let secretKey: String?
        public let securityToken: String?
        
        enum CodingKeys: String, CodingKey {
            case accessKey = "access_key"
            case expiration
            case secretKey = "secret_key"
            case securityToken = "security_token"
        }
    }
}
