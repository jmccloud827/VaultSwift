import Foundation

public extension Vault.AWS {
    struct LeaseConfig: Codable, Sendable {
        public let lease: String?
        public let maximumLease: String?
        
        public init(lease: String?, maximumLease: String?) {
            self.lease = lease
            self.maximumLease = maximumLease
        }
        
        enum CodingKeys: String, CodingKey {
            case lease
            case maximumLease = "lease_max"
        }
    }
}
