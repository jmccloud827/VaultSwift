import Foundation

public extension Vault.Transform {
    struct EncodeResponse: Decodable, Sendable {
        public let encodedItems: [Item]
        
        enum CodingKeys: String, CodingKey {
            case encodedItems = "batch_input"
        }
        
        public struct Item: Decodable, Sendable {
            public let encodedValue: String?
            public let tweak: String?
            
            enum CodingKeys: String, CodingKey {
                case encodedValue = "encoded_value"
                case tweak
            }
        }
    }
}
