import Foundation

public extension Vault.KeyManagement {
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
