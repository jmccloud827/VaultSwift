import Foundation

public extension Vault.SecretEngines.OpenLDAPClient {
    struct DynamicRole: Codable, Sendable {
        public let creationLDIF: String?
        public let deletionLDIF: String?
        public let rollbackLDIF: String?
        public let usernameTemplate: String?
        
        public init(creationLDIF: String?, deletionLDIF: String?, rollbackLDIF: String?, usernameTemplate: String?) {
            self.creationLDIF = creationLDIF
            self.deletionLDIF = deletionLDIF
            self.rollbackLDIF = rollbackLDIF
            self.usernameTemplate = usernameTemplate
        }
        
        enum CodingKeys: String, CodingKey {
            case creationLDIF = "creation_ldif"
            case deletionLDIF = "deletion_ldif"
            case rollbackLDIF = "rollback_ldif"
            case usernameTemplate = "username_template"
        }
    }
}
