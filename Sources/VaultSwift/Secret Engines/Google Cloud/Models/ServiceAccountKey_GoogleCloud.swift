import Foundation

public extension Vault.SecretEngines.GoogleCloudClient {
    struct ServiceAccountKey: Decodable, Sendable {
        public let base64EncodedPrivateKeyData: String
        public let keyAlgorithm: AlgorithmType
        public let privateKeyType: PrivateKeyType
        
        enum CodingKeys: String, CodingKey {
            case base64EncodedPrivateKeyData = "private_key_data"
            case keyAlgorithm = "key_algorithm"
            case privateKeyType = "key_type"
        }
        
        public enum AlgorithmType: String, Decodable, Sendable {
            case unspecified = "KEY_ALG_UNSPECIFIED"
            case _1028 = "KEY_ALG_RSA_1024"
            case _2048 = "KEY_ALG_RSA_2048"
        }
        
        public enum PrivateKeyType: String, Decodable, Sendable {
            case unspecified = "TYPE_UNSPECIFIED"
            case pkcs12 = "TYPE_PKCS12_FILE"
            case googleCredentials = "TYPE_GOOGLE_CREDENTIALS_FILE"
        }
    }
}
