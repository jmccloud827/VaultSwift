import Foundation

public extension Vault {
    /// A structure representing user credentials.
    struct UserCredentials: Decodable, Sendable {
        public let username: String
        public let password: String
            
        enum CodingKeys: String, CodingKey {
            case username
            case password
        }
    }
}
