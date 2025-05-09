import Foundation

public extension Vault.SecretEngines.IdentityClient {
    struct MergeEntitiesRequest: Encodable, Sendable {
        public let fromEntityIDs: [String]
        public let toEntityID: String
        public let force: Bool
        
        public init(fromEntityIDs: [String], toEntityID: String, force: Bool) {
            self.fromEntityIDs = fromEntityIDs
            self.toEntityID = toEntityID
            self.force = force
        }
        
        enum CodingKeys: String, CodingKey {
            case fromEntityIDs = "from_entity_ids"
            case toEntityID = "to_entity_id"
            case force
        }
    }
}
