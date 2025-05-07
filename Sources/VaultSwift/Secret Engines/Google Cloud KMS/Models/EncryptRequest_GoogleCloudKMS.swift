import Foundation

public extension Vault.SecretEngines.GoogleCloudKMSClient {
    struct EncryptRequest: Encodable, Sendable {
        public let keyVersion: Int?
        public let plainText: String?
        public let additionalAuthenticatedData: String?
        
        public init(keyVersion: Int?, plainText: String?, additionalAuthenticatedData: String?) {
            self.keyVersion = keyVersion
            self.plainText = plainText
            self.additionalAuthenticatedData = additionalAuthenticatedData
        }
        
        enum CodingKeys: String, CodingKey {
            case keyVersion = "key_version"
            case plainText = "plaintext"
            case additionalAuthenticatedData = "additional_authenticated_data"
        }
    }
}
