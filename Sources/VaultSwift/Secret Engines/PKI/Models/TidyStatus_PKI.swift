import Foundation

public extension Vault.SecretEngines.PKIClient {
    struct TidyStatus: Decodable, Sendable {
        let safetyBuffer: String?
        let tidyCertStore: Bool?
        let tidyRevokedCerts: Bool?
        let tidyState: TidyState?
        let error: String?
        let timeStarted: Date?
        let timeFinished: Date?
        let message: String?
        let certStoreDeletedCount: Int?
        let revokedCertDeletedCount: String?

        enum CodingKeys: String, CodingKey {
            case safetyBuffer = "safety_buffer"
            case tidyCertStore = "tidy_cert_store"
            case tidyRevokedCerts = "tidy_revoked_certs"
            case tidyState = "state"
            case error = "error"
            case timeStarted = "time_started"
            case timeFinished = "time_finished"
            case message = "message"
            case certStoreDeletedCount = "cert_store_deleted_count"
            case revokedCertDeletedCount = "revoked_cert_deleted_count"
        }
        
        public enum TidyState: String, Decodable, Sendable {
            case inactive
            case running
            case finished
            case error
        }
    }
}
