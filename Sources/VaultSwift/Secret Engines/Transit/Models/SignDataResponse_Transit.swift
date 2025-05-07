import Foundation

public extension Vault.SecretEngines.TransitClient {
    struct SignDataResponse: Decodable, Sendable {
        public let errorResponse: String?
        public let keyVersion: Int?
        public let publicKey: String?
        public let signature: String?
        public let batchResults: [Self]?
        
        enum CodingKeys: String, CodingKey {
            case errorResponse = "error"
            case keyVersion = "key_version"
            case publicKey = "publickey"
            case signature
            case batchResults = "batch_results"
        }
    }
}
