import Foundation

public extension Vault.Transform {
    struct CodingOptions: Encodable, Sendable {
        public let batchItems: [Item]
        
        public init(batchItems: [Item]) {
            self.batchItems = batchItems
        }
        
        enum CodingKeys: String, CodingKey {
            case batchItems = "batch_input"
        }
        
        public struct Item: Encodable, Sendable {
            public let value: String?
            public let transformation: String?
            public let tweak: String?
            
            public init(value: String?, transformation: String?, tweak: String?) {
                self.value = value
                self.transformation = transformation
                self.tweak = tweak
            }
            
            enum CodingKeys: String, CodingKey {
                case value
                case transformation
                case tweak
            }
        }
    }
}
