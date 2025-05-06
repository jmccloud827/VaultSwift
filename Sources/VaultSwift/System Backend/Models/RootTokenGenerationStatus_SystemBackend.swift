import Foundation

public extension Vault.SystemBackend {
    struct RootTokenGenerationStatus: Decodable, Sendable {
        public let nonce: String?
        public let started: Bool?
        public let unsealKeysProvided: Int?
        public let requiredUnsealKeys: Int?
        public let complete: Bool?
        public let encodedToken: String?
        public let encodedRootToken: String?
        public let pgpFingerPrint: String?
        public let otp: String?
        public let otpLength: Int?
        
        enum CodingKeys: String, CodingKey {
            case nonce
            case started
            case unsealKeysProvided = "progress"
            case requiredUnsealKeys = "required"
            case complete
            case encodedToken = "encoded_token"
            case encodedRootToken = "encoded_root_token"
            case pgpFingerPrint = "pgp_fingerprint"
            case otp
            case otpLength = "otp_length"
        }
    }
}
