import Foundation

public extension Vault.AWS {
    struct Credentials: Decodable, Sendable {
        public let accessKey: String
        public let secretKey: String
        public let securityToken: String
        
        enum CodingKeys: String, CodingKey {
            case accessKey = "access_key"
            case secretKey = "secret_key"
            case securityToken = "security_token"
        }
    }
}
