import Foundation

public extension Vault.SecretEngines.IdentityClient {
    struct MergeEntitiesRequest: Encodable, Sendable {
        public let fromEntityIds: [String]
        public let toEntityId: String
        public let force: Bool
        
        public init(fromEntityIds: [String], toEntityId: String, force: Bool) {
            self.fromEntityIds = fromEntityIds
            self.toEntityId = toEntityId
            self.force = force
        }
        
        enum CodingKeys: String, CodingKey {
            case fromEntityIds = "from_entity_ids"
            case toEntityId = "to_entity_id"
            case force
        }
    }
}
