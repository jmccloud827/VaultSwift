import Foundation

public extension Vault.SecretEngines.TransitClient {
    struct HMACRequest: Encodable, Sendable {
        public let keyVersion: Int?
        public let base64EncodedInput: String?
        public let batchInput: [Self]?
        
        public init(keyVersion: Int?, base64EncodedInput: String?, batchInput: [Self]?) {
            self.keyVersion = keyVersion
            self.base64EncodedInput = base64EncodedInput
            self.batchInput = batchInput
        }
        
        enum CodingKeys: String, CodingKey {
            case keyVersion = "key_version"
            case base64EncodedInput = "input"
            case batchInput = "batch_input"
        }
    }
}
