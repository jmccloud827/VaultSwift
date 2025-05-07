import Foundation

public extension Vault.SystemBackend.EnterpriseClient {
    struct ControlGroupConfig: Codable, Sendable {
        public let maxTimeToLive: String?
        
        public init(maxTimeToLive: String?) {
            self.maxTimeToLive = maxTimeToLive
        }

        enum CodingKeys: String, CodingKey {
            case maxTimeToLive = "max_ttl"
        }
    }
}
