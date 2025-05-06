import Foundation

public extension Vault.SystemBackend {
    struct RenewLeaseRequest: Encodable, Sendable {
        public let lease: String
        public let incrementSeconds: Int

        enum CodingKeys: String, CodingKey {
            case lease = "lease_id"
            case incrementSeconds = "increment"
        }
    }
}
