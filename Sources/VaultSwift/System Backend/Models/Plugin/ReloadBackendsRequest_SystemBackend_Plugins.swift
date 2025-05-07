import Foundation

public extension Vault.SystemBackend.PluginsClient {
    struct ReloadBackendsRequest: Encodable, Sendable {
        public let plugin: String
        public let mounts: [String]
        
        public init(plugin: String, mounts: [String]) {
            self.plugin = plugin
            self.mounts = mounts
        }
        
        enum CodingKeys: String, CodingKey {
            case plugin
            case mounts
        }
    }
}
