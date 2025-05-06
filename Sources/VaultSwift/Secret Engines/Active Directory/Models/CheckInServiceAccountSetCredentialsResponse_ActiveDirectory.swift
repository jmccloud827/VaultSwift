import Foundation

public extension Vault.ActiveDirectory {
    struct CheckInServiceAccountSetCredentialsResponse: Decodable, Sendable {
        public let accountNames: [String]?

        enum CodingKeys: String, CodingKey {
            case accountNames = "check_ins"
        }
    }
}
