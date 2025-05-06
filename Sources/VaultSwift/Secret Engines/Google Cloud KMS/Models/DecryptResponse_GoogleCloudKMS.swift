import Foundation

public extension Vault.GoogleCloudKMS {
    struct DecryptResponse: Decodable, Sendable {
        public let plainText: String?
        
        enum CodingKeys: String, CodingKey {
            case plainText = "plaintext"
        }
    }
}
