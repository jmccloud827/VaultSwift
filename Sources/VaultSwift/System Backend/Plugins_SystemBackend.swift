import Foundation

public extension Vault.SystemBackend {
    /// A client for interacting with Vault system backend plugins.
    struct PluginsClient {
        private let client: Vault.Client
        private let basePath = "v1/sys/plugins"
         
        /// Initializes a new `PluginsClient`.
        ///
        /// - Parameter client: The `Vault.Client` instance to use for making requests.
        init(client: Vault.Client) {
            self.client = client
        }
         
        /// Reloads the backends for the specified plugin.
        ///
        /// - Parameter plugin: The `ReloadBackendsRequest` containing the plugin details to reload.
        /// - Throws: An error if the request fails.
        public func reloadBackendsFor(plugin: ReloadBackendsRequest) async throws {
            try await client.makeCall(path: basePath + "/reload/backend", httpMethod: .put, request: plugin, wrapTimeToLive: nil)
        }
         
        /// Retrieves the catalog of plugins.
        ///
        /// - Returns: A `VaultResponse` containing `Vault.Keys`.
        /// - Throws: An error if the request fails.
        public func getCatalog() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: basePath + "/catalog", httpMethod: .list, wrapTimeToLive: nil)
        }
         
        /// Registers a new plugin.
        ///
        /// - Parameters:
        ///   - plugin: The name of the plugin to register.
        ///   - sha256: The SHA-256 checksum of the plugin binary.
        ///   - command: The command to execute the plugin.
        /// - Throws: An error if the request fails.
        public func register(plugin: String, sha256: String, command: String) async throws {
            let request = ["sha_256": sha256, "command": command]
            try await client.makeCall(path: basePath + "/catalog/" + plugin.trim(), httpMethod: .put, request: request, wrapTimeToLive: nil)
        }
         
        /// Unregisters an existing plugin.
        ///
        /// - Parameters:
        ///   - plugin: The name of the plugin to unregister.
        ///   - sha256: The SHA-256 checksum of the plugin binary.
        ///   - command: The command to execute the plugin.
        /// - Throws: An error if the request fails.
        public func unregister(plugin: String, sha256 _: String, command _: String) async throws {
            try await client.makeCall(path: basePath + "/catalog/" + plugin.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
         
        /// Retrieves the details of a specific plugin.
        ///
        /// - Parameter plugin: The name of the plugin to retrieve.
        /// - Returns: A `VaultResponse` containing the `Plugin` details.
        /// - Throws: An error if the request fails.
        public func get(plugin: String) async throws -> VaultResponse<Plugin> {
            try await client.makeCall(path: basePath + "/catalog/" + plugin.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
    }
}
