import Foundation

public extension Vault.SecretEngines.TransitClient {
    struct HashRequest: Encodable, Sendable {
        public let base64EncodedInput: Int
        public let format: OutputEncodingFormat
        
        enum CodingKeys: String, CodingKey {
            case base64EncodedInput = "input"
            case format
        }
    }
}
