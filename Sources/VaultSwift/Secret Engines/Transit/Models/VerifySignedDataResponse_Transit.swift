import Foundation

public extension Vault.SecretEngines.TransitClient {
    struct VerifySignedDataResponse: Decodable, Sendable {
        public let valid: Bool?
        public let batchResults: [Self]?
        
        enum CodingKeys: String, CodingKey {
            case valid
            case batchResults = "batch_results"
        }
    }
}
