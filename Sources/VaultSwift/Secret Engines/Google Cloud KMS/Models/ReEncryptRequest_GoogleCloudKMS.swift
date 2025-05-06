import Foundation

public extension Vault.GoogleCloudKMS {
    struct ReEncryptRequest: Encodable, Sendable {
        public let keyVersion: Int?
        public let cipherText: String?
        public let additionalAuthenticatedData: String?
        
        public init(keyVersion: Int?, cipherText: String?, additionalAuthenticatedData: String?) {
            self.keyVersion = keyVersion
            self.cipherText = cipherText
            self.additionalAuthenticatedData = additionalAuthenticatedData
        }
        
        enum CodingKeys: String, CodingKey {
            case keyVersion = "key_version"
            case cipherText = "ciphertext"
            case additionalAuthenticatedData = "additional_authenticated_data"
        }
    }
}
