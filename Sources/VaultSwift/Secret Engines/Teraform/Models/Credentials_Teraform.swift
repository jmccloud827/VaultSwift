import Foundation

public extension Vault.SecretEngines.TerraformClient {
    struct Credentials: Decodable, Sendable {
        public let token: String?
        public let tokenID: String?
        
        enum CodingKeys: String, CodingKey {
            case token
            case tokenID = "token_id"
        }
    }
}
