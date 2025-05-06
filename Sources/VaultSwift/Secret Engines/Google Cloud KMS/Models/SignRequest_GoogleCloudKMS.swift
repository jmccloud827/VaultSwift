import Foundation

public extension Vault.GoogleCloudKMS {
    struct SignRequest: Encodable, Sendable {
        public let keyVersion: Int?
        public let digest: String?
        
        public init(keyVersion: Int?, digest: String?) {
            self.keyVersion = keyVersion
            self.digest = digest
        }
        
        enum CodingKeys: String, CodingKey {
            case keyVersion = "key_version"
            case digest
        }
    }
}
