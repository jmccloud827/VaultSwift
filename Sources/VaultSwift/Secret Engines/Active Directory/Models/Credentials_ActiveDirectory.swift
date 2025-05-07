import Foundation

public extension Vault.SecretEngines.ActiveDirectoryClient {
    struct Credentials: Decodable, Sendable {
        public let currentPassword: String
        public let lastPassword: String
        public let username: String
        
        enum CodingKeys: String, CodingKey {
            case currentPassword = "current_password"
            case lastPassword = "last_password"
            case username = "username"
        }
    }
}
