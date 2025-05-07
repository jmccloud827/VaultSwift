import Foundation

public extension Vault.SecretEngines.RabbitMQClient {
    struct Lease: Encodable, Sendable {
        public let timeToLive: Int?
        public let maximumTimeToLive: Int?
        
        public init(timeToLive: Int?, maximumTimeToLive: Int?) {
            self.timeToLive = timeToLive
            self.maximumTimeToLive = maximumTimeToLive
        }
        
        enum CodingKeys: String, CodingKey {
            case timeToLive = "ttl"
            case maximumTimeToLive = "max_ttl"
        }
    }
}
