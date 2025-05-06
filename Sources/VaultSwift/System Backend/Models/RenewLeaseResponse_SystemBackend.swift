import Foundation

public extension Vault.SystemBackend {
    struct RenewLeaseResponse: Decodable, Sendable {
        public let leaseId: String?
        public let renewable: Bool?
        public let leaseDuration: Int?

        enum CodingKeys: String, CodingKey {
            case leaseId = "lease_id"
            case renewable = "renewable"
            case leaseDuration = "lease_duration"
        }
    }
}
