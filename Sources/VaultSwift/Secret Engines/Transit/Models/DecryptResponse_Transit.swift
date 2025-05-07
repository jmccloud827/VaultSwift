import Foundation

public extension Vault.SecretEngines.TransitClient {
    struct DecryptResponse: Decodable, Sendable {
        public let base64EncodedPlainText: String?
        public let batchResults: [Self]?
        
        enum CodingKeys: String, CodingKey {
            case base64EncodedPlainText = "plaintext"
            case batchResults = "batch_results"
        }
    }
}
