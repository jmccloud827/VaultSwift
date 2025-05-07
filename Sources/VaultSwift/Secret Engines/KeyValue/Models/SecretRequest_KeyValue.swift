import Foundation

public extension Vault.SecretEngines.KeyValueClient {
    struct SecretRequest<T: Encodable>: Encodable {
        public let data: T
        public let options: Options?
        
        public init(data: T, options: Options? = nil) {
            self.data = data
            self.options = options
        }
        
        enum CodingKeys: String, CodingKey {
            case data
            case options
        }
        
        public struct Options: Encodable, Sendable {
            public let checkAndSet: Int?
            
            public init(checkAndSet: Int? = nil) {
                self.checkAndSet = checkAndSet
            }
            
            enum CodingKeys: String, CodingKey {
                case checkAndSet = "cas"
            }
        }
    }
}
