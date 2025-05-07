import Foundation

public extension Vault.SystemBackend.EnterpriseClient {
    struct RGPPolicy: Codable, Sendable {
        public let name: String?
        public let policy: String?
        public let enforcementLevel: EnforcementLevel?
        
        public init(name: String?, policy: String?, enforcementLevel: EnforcementLevel?) {
            self.name = name
            self.policy = policy
            self.enforcementLevel = enforcementLevel
        }

        enum CodingKeys: String, CodingKey {
            case name
            case policy
            case enforcementLevel = "enforcement_level"
        }
    }
}
