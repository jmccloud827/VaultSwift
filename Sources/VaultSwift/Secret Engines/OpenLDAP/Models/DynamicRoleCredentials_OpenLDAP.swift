import Foundation

public extension Vault.SecretEngines.OpenLDAPClient {
    struct DynamicRoleCredentials: Decodable, Sendable {
        public let username: String?
        public let password: String?
        public let distinguishedNames: [String]?
        
        enum CodingKeys: String, CodingKey {
            case username
            case password
            case distinguishedNames = "distinguished_names"
        }
    }
}
