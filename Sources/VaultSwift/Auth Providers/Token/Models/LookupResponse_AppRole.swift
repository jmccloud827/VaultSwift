import Foundation

public extension Vault.AuthProviders.TokenClient {
    struct LookupResponse: Decodable, Sendable {
        public let accessor: String?
        public let explicitMaximumTimeToLive: Int?
        public let renewable: Bool?

        enum CodingKeys: String, CodingKey {
            case accessor = "accessor"
            case explicitMaximumTimeToLive = "explicit_max_ttl"
            case renewable = "renewable"
        }
    }
}
