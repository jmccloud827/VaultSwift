import Foundation

public extension Vault.GoogleCloudKMS {
    struct SignResponse: Decodable, Sendable {
        public let signature: String
        
        enum CodingKeys: String, CodingKey {
            case signature
        }
    }
}
