import Foundation

public extension Vault.AuthProviders.JWTClient {
    struct AuthResponse: Decodable, Sendable {
        public let clientTokenAccessor: String?
        public let clientToken: String?
        public let policies: [String]?
        public let metadata: [String: String]?
        public let leaseDurationSeconds: Int?
        public let renewable: Bool?

        enum CodingKeys: String, CodingKey {
            case clientTokenAccessor = "accessor"
            case clientToken = "client_token"
            case policies
            case metadata
            case leaseDurationSeconds = "lease_duration"
            case renewable
        }
    }
}
