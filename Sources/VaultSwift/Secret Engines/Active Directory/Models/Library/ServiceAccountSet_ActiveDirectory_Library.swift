import Foundation

public extension Vault.SecretEngines.ActiveDirectoryLibrary {
    struct ServiceAccountSet: Codable, Sendable {
        public let disableCheckInEnforcement: Bool
        public let maximumTimeToLive: Int
        public let serviceAccountNames: [String]
        public let timeToLive: Int
        
        public init(disableCheckInEnforcement: Bool,
                    maximumTimeToLive: Int = 24 * 60 * 60,
                    serviceAccountNames: [String],
                    timeToLive: Int = 24 * 60 * 60) {
            self.disableCheckInEnforcement = disableCheckInEnforcement
            self.maximumTimeToLive = maximumTimeToLive
            self.serviceAccountNames = serviceAccountNames
            self.timeToLive = timeToLive
        }

        enum CodingKeys: String, CodingKey {
            case disableCheckInEnforcement = "disable_check_in_enforcement"
            case maximumTimeToLive = "max_ttl"
            case serviceAccountNames = "service_account_names"
            case timeToLive = "ttl"
        }
    }
}
