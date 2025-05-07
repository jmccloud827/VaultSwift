import Foundation

public extension Vault.SecretEngines.KeyManagementClient {
    struct KMSKey: Decodable, Sendable {
        public let name: String?
        public let protection: String?
        public let purpose: String?
        
        enum CodingKeys: String, CodingKey {
            case name
            case protection
            case purpose
        }
    }
}
