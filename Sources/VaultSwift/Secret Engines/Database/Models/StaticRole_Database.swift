import Foundation

public extension Vault.Database {
    struct StaticRole: Codable, Sendable {
        let username: String?
        let databaseProviderType: DatabaseProviderType?
        let rotationStatements: [String]?
        let rotationPeriod: Int?
        
        public init(username: String?, databaseProviderType: DatabaseProviderType?, rotationStatements: [String]?, rotationPeriod: Int?) {
            self.username = username
            self.databaseProviderType = databaseProviderType
            self.rotationStatements = rotationStatements
            self.rotationPeriod = rotationPeriod
        }

        enum CodingKeys: String, CodingKey {
            case username
            case databaseProviderType = "db_name"
            case rotationStatements = "rotation_statements"
            case rotationPeriod = "rotation_period"
        }
    }
}
