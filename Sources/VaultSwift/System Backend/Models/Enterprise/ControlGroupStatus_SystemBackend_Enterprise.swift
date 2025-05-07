import Foundation

public extension Vault.SystemBackend.EnterpriseClient {
    struct ControlGroupStatus: Decodable, Sendable {
        public let approved: Bool?
        public let requestPath: String?
        public let requestEntity: RequestEntity?
        public let authorizations: [Authorization]?

        enum CodingKeys: String, CodingKey {
            case approved
            case requestPath = "request_path"
            case requestEntity = "request_entity"
            case authorizations
        }
        
        public struct RequestEntity: Decodable, Sendable {
            public let id: String?
            public let name: String?
            
            enum CodingKeys: String, CodingKey {
                case id
                case name
            }
        }
        
        public struct Authorization: Decodable, Sendable {
            public let entityID: String?
            public let entityName: String?
            
            enum CodingKeys: String, CodingKey {
                case entityID = "entity_id"
                case entityName = "entity_name"
            }
        }
    }
}
