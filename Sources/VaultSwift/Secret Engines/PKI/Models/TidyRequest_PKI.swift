import Foundation

public extension Vault.PKI {
    struct TidyRequest: Encodable, Sendable {
        public let tidyCertStore: Bool
        public let tidyRevokedCerts: Bool
        public let tidyRevokedCertIssuerAssociations: Bool
        public let tidyExpiredIssuers: Bool
        public let safetyBuffer: String
        public let issuerSafetyBuffer: String
        public let pauseDuration: String
        
        public init(tidyCertStore: Bool = false,
                    tidyRevokedCerts: Bool = false,
                    tidyRevokedCertIssuerAssociations: Bool = false,
                    tidyExpiredIssuers: Bool = false,
                    safetyBuffer: String = "72h",
                    issuerSafetyBuffer: String = "8760h",
                    pauseDuration: String = "0s") {
            self.tidyCertStore = tidyCertStore
            self.tidyRevokedCerts = tidyRevokedCerts
            self.tidyRevokedCertIssuerAssociations = tidyRevokedCertIssuerAssociations
            self.tidyExpiredIssuers = tidyExpiredIssuers
            self.safetyBuffer = safetyBuffer
            self.issuerSafetyBuffer = issuerSafetyBuffer
            self.pauseDuration = pauseDuration
        }
        
        enum CodingKeys: String, CodingKey {
            case tidyCertStore = "tidy_cert_store"
            case tidyRevokedCerts = "tidy_revoked_certs"
            case tidyRevokedCertIssuerAssociations = "tidy_revoked_cert_issuer_associations"
            case tidyExpiredIssuers = "tidy_expired_issuers"
            case safetyBuffer = "safety_buffer"
            case issuerSafetyBuffer = "issuer_safety_buffer"
            case pauseDuration = "pause_duration"
        }
    }
}
