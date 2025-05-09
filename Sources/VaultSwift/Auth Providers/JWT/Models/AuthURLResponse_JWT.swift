import Foundation

public extension Vault.AuthProviders.JWTClient {
    struct AuthURLResponse: Decodable, Sendable {
        public let authorizationURL: String?

        enum CodingKeys: String, CodingKey {
            case authorizationURL = "auth_url"
        }
    }
}
