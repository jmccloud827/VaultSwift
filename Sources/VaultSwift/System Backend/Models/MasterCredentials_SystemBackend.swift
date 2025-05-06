import Foundation

public extension Vault.SystemBackend {
    struct MasterCredentials: Decodable, Sendable {
        public let masterKeys: [String]?
        public let base64MasterKeys: [String]?
        public let rootToken: String?

        enum CodingKeys: String, CodingKey {
            case masterKeys = "keys"
            case base64MasterKeys = "keys_base64"
            case rootToken = "root_token"
        }
    }
}
