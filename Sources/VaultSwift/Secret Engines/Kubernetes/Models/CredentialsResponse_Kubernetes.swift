import Foundation

public extension Vault.Kubernetes {
    struct CredentialsResponse: Decodable, Sendable {
        public let serviceAccountName: String
        public let serviceAccountNamespace: String?
        public let serviceAccountToken: String?
        
        enum CodingKeys: String, CodingKey {
            case serviceAccountName = "service_account_name"
            case serviceAccountNamespace = "service_account_namespace"
            case serviceAccountToken = "service_account_token"
        }
    }
}
