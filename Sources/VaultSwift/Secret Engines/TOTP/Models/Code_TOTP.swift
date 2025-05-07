import Foundation

public extension Vault.SecretEngines.TOTPClient {
    struct Code: Decodable, Sendable {
        public let code: String?
        
        enum CodingKeys: String, CodingKey {
            case code
        }
    }
}
