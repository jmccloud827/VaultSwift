import Foundation

public extension Vault.Azure {
    struct Credentials: Decodable, Sendable {
        public let clientID: String
        public let clientSecret: String
        
        enum CodingKeys: String, CodingKey {
            case clientID = "client_id"
            case clientSecret = "client_secret"
        }
    }
}
