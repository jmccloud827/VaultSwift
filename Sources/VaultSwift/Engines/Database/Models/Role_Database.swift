import Foundation

public extension Vault.Database {
    struct Role: Codable, Sendable {
        public let databaseProviderType: DatabaseProviderType?
        public let defaultTimeToLive: Int?
        public let maximumTimeToLive: Int?
        public let creationStatements: [String]?
        public let revocationStatements: [String]?
        public let rollbackStatements: [String]?
        public let renewStatements: [String]?
        
        public init(databaseProviderType: DatabaseProviderType?,
                    defaultTimeToLive: Int?,
                    maximumTimeToLive: Int?,
                    creationStatements: [String]?,
                    revocationStatements: [String]?,
                    rollbackStatements: [String]?,
                    renewStatements: [String]?) {
            self.databaseProviderType = databaseProviderType
            self.defaultTimeToLive = defaultTimeToLive
            self.maximumTimeToLive = maximumTimeToLive
            self.creationStatements = creationStatements
            self.revocationStatements = revocationStatements
            self.rollbackStatements = rollbackStatements
            self.renewStatements = renewStatements
        }

        enum CodingKeys: String, CodingKey {
            case databaseProviderType = "db_name"
            case defaultTimeToLive = "default_ttl"
            case maximumTimeToLive = "max_ttl"
            case creationStatements = "creation_statements"
            case revocationStatements = "revocation_statements"
            case rollbackStatements = "rollback_statements"
            case renewStatements = "renew_statements"
        }
    }
    
    enum DatabaseProviderType: String, Codable, Sendable {
        case mysql
        case postgressql
        case mongodb
        case oracle
        case redshift
    }
}
