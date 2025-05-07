import Foundation

public extension Vault.SystemBackend.EnterpriseClient {
    enum EnforcementLevel: String, Codable, Sendable {
        case advisory
        case softMandatory = "soft-mandatory"
        case hardMandatory = "hard-mandatory"
    }
}
