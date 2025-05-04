import Foundation

public extension Vault {
    struct Keys: Decodable, Sendable {
        public let keys: [String]
            
        enum CodingKeys: String, CodingKey {
            case keys
        }
    }
}
