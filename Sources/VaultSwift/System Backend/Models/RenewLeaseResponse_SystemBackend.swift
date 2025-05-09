import Foundation

public extension Vault.SystemBackend {
    struct RenewLeaseResponse: Decodable, Sendable {
        public let leaseID: String?
        public let renewable: Bool?
        public let leaseDuration: Int?

        enum CodingKeys: String, CodingKey {
            case leaseID = "lease_id"
            case renewable
            case leaseDuration = "lease_duration"
        }
    }
}
