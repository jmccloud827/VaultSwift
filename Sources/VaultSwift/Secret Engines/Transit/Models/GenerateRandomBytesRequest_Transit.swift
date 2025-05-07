import Foundation

public extension Vault.SecretEngines.TransitClient {
    struct GenerateRandomBytesRequest: Encodable, Sendable {
        public let bytesToGenerate: Int
        public let format: OutputEncodingFormat
        
        public init(bytesToGenerate: Int, format: OutputEncodingFormat = .base64) {
            self.bytesToGenerate = bytesToGenerate
            self.format = format
        }
        
        enum CodingKeys: String, CodingKey {
            case bytesToGenerate = "bytes"
            case format
        }
        
        public enum OutputEncodingFormat: String, Encodable, Sendable {
            case base64
            case hex
        }
    }
    
    enum RandomBytesSourceType: String, Sendable {
        case platform
        case seal
        case all
    }
}
