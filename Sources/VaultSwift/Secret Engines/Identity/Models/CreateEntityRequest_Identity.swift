import Foundation

public extension Vault.SecretEngines.IdentityClient {
    struct CreateEntityRequest: Encodable, Sendable {
        public let id: String?
        public let name: String?
        public let metadata: [String: String]?
        public let policies: [String]?
        public let disabled: Bool
        
        public init(id: String?, name: String?, metadata: [String : String]?, policies: [String]?, disabled: Bool) {
            self.id = id
            self.name = name
            self.metadata = metadata
            self.policies = policies
            self.disabled = disabled
        }
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case metadata
            case policies
            case disabled
        }
    }
}
