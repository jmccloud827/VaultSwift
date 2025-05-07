import Foundation

public extension Vault.SecretEngines.IdentityClient {
    struct KeyRequest: Encodable, Sendable {
        public let rotationPeriod: String?
        public let verificationTimeToLive: String?
        public let algorithm: String?
        public let allowedClientIDs: [String]?
        
        public init(rotationPeriod: String?, verificationTimeToLive: String?, algorithm: String?, allowedClientIDs: [String]?) {
            self.rotationPeriod = rotationPeriod
            self.verificationTimeToLive = verificationTimeToLive
            self.algorithm = algorithm
            self.allowedClientIDs = allowedClientIDs
        }
        
        enum CodingKeys: String, CodingKey {
            case rotationPeriod = "rotation_period"
            case verificationTimeToLive = "verification_ttl"
            case algorithm
            case allowedClientIDs = "allowed_client_ids"
        }
    }
}
