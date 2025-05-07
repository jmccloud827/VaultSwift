import Foundation

public extension Vault.SecretEngines.PKIClient {
    struct AutoTidyRequest: Encodable, Sendable {
        public let enabled: Bool
        public let intervalDuration: String
        public let tidyCertStore: Bool
        public let tidyRevokedCerts: Bool
        public let tidyRevokedCertIssuerAssociations: Bool
        public let tidyExpiredIssuers: Bool
        public let safetyBuffer: String
        public let issuerSafetyBuffer: String
        
        public init(enabled: Bool = true,
                    intervalDuration: String = "12h",
                    tidyCertStore: Bool = false,
                    tidyRevokedCerts: Bool = false,
                    tidyRevokedCertIssuerAssociations: Bool = false,
                    tidyExpiredIssuers: Bool = false,
                    safetyBuffer: String = "72h",
                    issuerSafetyBuffer: String = "8760h") {
            self.enabled = enabled
            self.intervalDuration = intervalDuration
            self.tidyCertStore = tidyCertStore
            self.tidyRevokedCerts = tidyRevokedCerts
            self.tidyRevokedCertIssuerAssociations = tidyRevokedCertIssuerAssociations
            self.tidyExpiredIssuers = tidyExpiredIssuers
            self.safetyBuffer = safetyBuffer
            self.issuerSafetyBuffer = issuerSafetyBuffer
        }
        
        enum CodingKeys: String, CodingKey {
            case enabled
            case intervalDuration = "interval_duration"
            case tidyCertStore = "tidy_cert_store"
            case tidyRevokedCerts = "tidy_revoked_certs"
            case tidyRevokedCertIssuerAssociations = "tidy_revoked_cert_issuer_associations"
            case tidyExpiredIssuers = "tidy_expired_issuers"
            case safetyBuffer = "safety_buffer"
            case issuerSafetyBuffer = "issuer_safety_buffer"
        }
    }
}
