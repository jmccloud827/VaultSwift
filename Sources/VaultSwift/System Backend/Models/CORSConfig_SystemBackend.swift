import Foundation

public extension Vault.SystemBackend {
    struct CORSConfig: Codable, Sendable {
        public let enabled: Bool?
        public let allowedOrigins: [String]?
        public let allowedHeaders: [String]?
        
        public init(enabled: Bool?, allowedOrigins: [String]?, allowedHeaders: [String]?) {
            self.enabled = enabled
            self.allowedOrigins = allowedOrigins
            self.allowedHeaders = allowedHeaders
        }

        enum CodingKeys: String, CodingKey {
            case enabled
            case allowedOrigins = "allowed_origins"
            case allowedHeaders = "allowed_headers"
        }
    }
}
