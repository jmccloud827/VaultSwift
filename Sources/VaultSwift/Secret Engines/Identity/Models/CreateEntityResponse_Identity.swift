import Foundation

public extension Vault.Identity {
    struct CreateEntityResponse: Decodable, Sendable {
        public let id: String?
        public let name: String?
        public let aliases: [String]?
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case aliases
        }
    }
}
