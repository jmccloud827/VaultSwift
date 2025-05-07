import Foundation

public extension Vault.SecretEngines.TransitClient {
    struct CacheConfig: Codable, Sendable {
        public let size: Int?
        
        public init(size: Int?) {
            self.size = size
        }
        
        enum CodingKeys: String, CodingKey {
            case size
        }
    }
}
