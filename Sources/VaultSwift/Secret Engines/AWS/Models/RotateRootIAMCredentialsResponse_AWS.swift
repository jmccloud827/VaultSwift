import Foundation

public extension Vault.SecretEngines.AWSClient {
    struct RotateRootIAMCredentialsResponse: Decodable, Sendable {
        public let accessKey: String?
        
        enum CodingKeys: String, CodingKey {
            case accessKey = "access_key"
        }
    }
}
