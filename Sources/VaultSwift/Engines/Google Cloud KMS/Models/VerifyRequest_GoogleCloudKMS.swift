import Foundation

public extension Vault.GoogleCloudKMS {
    struct VerifyRequest: Encodable, Sendable {
        public let keyVersion: Int?
        public let digest: String?
        public let signature: String?
        
        public init(keyVersion: Int?, digest: String?, signature: String?) {
            self.keyVersion = keyVersion
            self.digest = digest
            self.signature = signature
        }
        
        enum CodingKeys: String, CodingKey {
            case keyVersion = "key_version"
            case digest
            case signature
        }
    }
}
