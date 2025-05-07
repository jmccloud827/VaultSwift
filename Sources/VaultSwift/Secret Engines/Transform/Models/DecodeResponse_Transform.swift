import Foundation

public extension Vault.SecretEngines.TransformClient {
    struct DecodeResponse: Decodable, Sendable {
        public let decodedItems: [Item]
        
        enum CodingKeys: String, CodingKey {
            case decodedItems = "batch_input"
        }
        
        public struct Item: Decodable, Sendable {
            public let decodedValue: String?
            public let tweak: String?
            
            enum CodingKeys: String, CodingKey {
                case decodedValue = "decoded_value"
                case tweak
            }
        }
    }
}
