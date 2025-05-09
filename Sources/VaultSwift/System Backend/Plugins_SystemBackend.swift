import Foundation

public extension Vault.SystemBackend {
    struct PluginsClient {
        private let client: Vault.Client
        private let basePath = "v1/sys/plugins"
            
        init(client: Vault.Client) {
            self.client = client
        }
        
        public func reloadBackendsFor(plugin: ReloadBackendsRequest) async throws {
            try await client.makeCall(path: basePath + "/reload/backend", httpMethod: .put, request: plugin, wrapTimeToLive: nil)
        }
        
        public func getCatalog() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: basePath + "/catalog", httpMethod: .list, wrapTimeToLive: nil)
        }
        
        public func register(plugin: String, sha256: String, command: String) async throws {
            let request = ["sha_256": sha256, "command": command]
            
            try await client.makeCall(path: basePath + "/catalog/" + plugin.trim(), httpMethod: .put, request: request, wrapTimeToLive: nil)
        }
        
        public func unregister(plugin: String, sha256: String, command: String) async throws {
            try await client.makeCall(path: basePath + "/catalog/" + plugin.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func get(plugin: String) async throws -> VaultResponse<Plugin> {
            try await client.makeCall(path: basePath + "/catalog/" + plugin.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
    }
}
