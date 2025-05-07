import Foundation

public extension Vault.SecretEngines.ActiveDirectoryLibrary {
    struct CheckInServiceAccountSetCredentialsResponse: Decodable, Sendable {
        public let accountNames: [String]?

        enum CodingKeys: String, CodingKey {
            case accountNames = "check_ins"
        }
    }
}
