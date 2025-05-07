import Foundation

public extension Vault.SecretEngines.TransitClient {
    struct GenerateRandomBytesResponse: Decodable, Sendable {
        public let encodedRandomBytes: String?
        
        enum CodingKeys: String, CodingKey {
            case encodedRandomBytes = "random_bytes"
        }
    }
}
