import Foundation

public extension Vault.SecretEngines.NomadClient {
    struct Credentials: Decodable, Sendable {
        public let accessorID: String?
        public let secretID: String?
        
        enum CodingKeys: String, CodingKey {
            case accessorID = "accessor_id"
            case secretID = "secret_id"
        }
    }
}
