import Foundation

public extension Vault.SecretEngines.TransitClient {
    struct HashResponse: Decodable, Sendable {
        public let hashSum: String?
        
        enum CodingKeys: String, CodingKey {
            case hashSum = "sum"
        }
    }
}
