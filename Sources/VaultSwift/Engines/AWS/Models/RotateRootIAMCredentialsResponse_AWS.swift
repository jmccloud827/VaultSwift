import Foundation

public extension Vault.AWS {
    struct RotateRootIAMCredentialsResponse: Decodable, Sendable {
        public let accessKey: String?
        
        enum CodingKeys: String, CodingKey {
            case accessKey = "access_key"
        }
    }
}
