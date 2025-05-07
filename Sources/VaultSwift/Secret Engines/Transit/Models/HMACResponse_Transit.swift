import Foundation

public extension Vault.SecretEngines.TransitClient {
    struct HMACResponse: Decodable, Sendable {
        public let hmac: String?
        public let errorResponse: String?
        public let batchResults: [Self]?
        
        enum CodingKeys: String, CodingKey {
            case hmac
            case errorResponse = "error"
            case batchResults = "batch_results"
        }
    }
}
