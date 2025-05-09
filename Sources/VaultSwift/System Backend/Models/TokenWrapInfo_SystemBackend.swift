import Foundation

public extension Vault.SystemBackend {
    struct TokenWrapInfo: Decodable, Sendable {
        public let creationPath: String?
        public let creationTime: String?
        public let creationTimeToLive: Int?

        enum CodingKeys: String, CodingKey {
            case creationPath = "creation_path"
            case creationTime = "creation_time"
            case creationTimeToLive = "creation_ttl"
        }
    }
}
