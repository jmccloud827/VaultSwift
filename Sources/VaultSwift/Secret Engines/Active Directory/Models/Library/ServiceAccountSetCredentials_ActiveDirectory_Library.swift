import Foundation

public extension Vault.SecretEngines.ActiveDirectoryLibrary {
    struct ServiceAccountSetCredentials: Decodable, Sendable {
        public let password: String?
        public let serviceAccountName: String?

        enum CodingKeys: String, CodingKey {
            case password
            case serviceAccountName = "service_account_name"
        }
    }
}
