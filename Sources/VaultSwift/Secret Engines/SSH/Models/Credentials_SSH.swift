import Foundation

public extension Vault.SSH {
    struct Credentials: Decodable, Sendable {
        public let ipAddress: String?
        public let key: String?
        public let keyType: KeyType?
        public let port: Int?
        public let username: String?
        
        enum CodingKeys: String, CodingKey {
            case ipAddress = "ip"
            case key
            case keyType = "key_type"
            case port
            case username
        }
        
        public enum KeyType: String, Decodable, Sendable {
            case otp
            case dynamic
            case ca
        }
    }
}
