import Foundation

public extension Vault.SystemBackend.EnterpriseClient {
    struct License: Decodable, Sendable {
        public let expirationTime: String?
        public let features: [String]?
        public let licenseId: String?
        public let startTime: String?

        enum CodingKeys: String, CodingKey {
            case expirationTime = "expiration_time"
            case features = "features"
            case licenseId = "license_id"
            case startTime = "start_time"
        }
    }
}
