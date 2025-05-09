import Foundation

public extension Vault {
    /// A structure representing a list of keys.
    struct Keys: Decodable, Sendable {
        public let keys: [String]
            
        enum CodingKeys: String, CodingKey {
            case keys
        }
    }
}
