import Foundation

public extension Vault.SystemBackend.EnterpriseClient {
    struct EGPPolicy: Codable, Sendable {
        public let name: String?
        public let policy: String?
        public let enforcementLevel: EnforcementLevel?
        public let paths: [String]?
        
        public init(name: String?, policy: String?, enforcementLevel: EnforcementLevel?, paths: [String]?) {
            self.name = name
            self.policy = policy
            self.enforcementLevel = enforcementLevel
            self.paths = paths
        }

        enum CodingKeys: String, CodingKey {
            case name
            case policy
            case enforcementLevel = "enforcement_level"
            case paths
        }
    }
}
