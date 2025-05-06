import Foundation

public extension Vault.RabbitMQ {
    struct Role: Codable, Sendable {
        public let tags: String?
        public let vHosts: String?
        public let vHostTopics: String?
        
        public init(tags: String?, vHosts: String?, vHostTopics: String?) {
            self.tags = tags
            self.vHosts = vHosts
            self.vHostTopics = vHostTopics
        }
        
        enum CodingKeys: String, CodingKey {
            case tags
            case vHosts = "vhosts"
            case vHostTopics = "vhost_topics"
        }
    }
}
