import Foundation

public extension Vault.SecretEngines.OpenLDAPClient {
    struct StaticRole: Codable, Sendable {
        public let username: String?
        public let distinguishedName: String?
        public let rotationPeriod: Int?
        
        public init(username: String?, distinguishedName: String?, rotationPeriod: Int?) {
            self.username = username
            self.distinguishedName = distinguishedName
            self.rotationPeriod = rotationPeriod
        }
        
        enum CodingKeys: String, CodingKey {
            case username
            case distinguishedName = "dn"
            case rotationPeriod = "rotation_period"
        }
    }
}
