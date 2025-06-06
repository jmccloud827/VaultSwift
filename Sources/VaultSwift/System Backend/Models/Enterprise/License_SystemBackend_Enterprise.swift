import Foundation

public extension Vault.SystemBackend.EnterpriseClient {
    struct License: Decodable, Sendable {
        public let expirationTime: String?
        public let features: [String]?
        public let licenseID: String?
        public let startTime: String?

        enum CodingKeys: String, CodingKey {
            case expirationTime = "expiration_time"
            case features
            case licenseID = "license_id"
            case startTime = "start_time"
        }
    }
}
