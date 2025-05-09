import Foundation

public extension Vault.SecretEngines.KeyValueClient {
    /// A client for interacting with the Vault Key-Value (KV) version 1 secret engine.
    struct V1: BackendClient {
        public let config: Config
        private let client: Vault.Client
        
        /// Initializes a new `V1` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the KV v1 client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
        
        /// Initializes a new `V1` instance with the specified configuration and Vault client.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the KV v1 client.
        ///   - client: The `Vault.Client` instance.
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// Retrieves the secret at the specified location.
        ///
        /// - Parameter secret: The path of the secret to retrieve.
        /// - Returns: A `VaultResponse` containing the secret data.
        /// - Throws: An error if the request fails or the secret path is empty.
        public func get(secret: String) async throws -> VaultResponse<[String: String]> {
            guard !secret.isEmpty else {
                throw VaultError(error: "Secret must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/" + secret.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Retrieves the secret at the specified location.
        ///
        /// - Parameter secret: The path of the secret to retrieve.
        /// - Returns: A `VaultResponse` containing the secret data of the specified type.
        /// - Throws: An error if the request fails or the secret path is empty.
        public func get<T: Decodable>(secret: String) async throws -> VaultResponse<T> {
            guard !secret.isEmpty else {
                throw VaultError(error: "Secret must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/" + secret.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Retrieves the secret location path entries at the specified location.
        /// Folders are suffixed with /. The input must be a folder; list on a file will not return a value.
        /// The values themselves are not accessible via this API.
        ///
        /// - Parameter path: The path to list secret paths from.
        /// - Returns: A `VaultResponse` containing the keys.
        /// - Throws: An error if the request fails.
        public func listSecretPathsFrom(path: String) async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/" + path.trim() + "\(path.isEmpty ? "" : "/")", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Stores a secret at the specified location. If the value does not yet exist, the calling token must have an ACL policy granting the create capability.
        /// If the value already exists, the calling token must have an ACL policy granting the update capability.
        ///
        /// - Remark: Unlike other secrets engines, the KV secrets engine does not enforce TTLs for expiration. Instead, the leaseDuration is a hint for how often consumers should check back for a new value. This is commonly displayed as refreshInterval instead of leaseDuration to clarify this in output. If provided a key of ttl, the KV secrets engine will utilize this value as the lease duration: Even with a ttl set, the secrets engine never removes data on its own.The ttl key is merely advisory. When reading a value with a ttl, both the ttl key and the refresh interval will reflect the value:
        ///
        /// - Parameters:
        ///   - secret: The path of the secret to write.
        ///   - values: A dictionary containing the secret values.
        /// - Returns: A `VaultResponse` containing the written secret data.
        /// - Throws: An error if the request fails or the secret path is empty.
        public func write(secret: String, values: [String: String]) async throws -> VaultResponse<[String: String]> {
            guard !secret.isEmpty else {
                throw VaultError(error: "Secret must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/" + secret.trim(), httpMethod: .post, request: values, wrapTimeToLive: nil)
        }
        
        /// Stores a secret at the specified location. If the value does not yet exist, the calling token must have an ACL policy granting the create capability.
        /// If the value already exists, the calling token must have an ACL policy granting the update capability.
        ///
        /// - Remark: Unlike other secrets engines, the KV secrets engine does not enforce TTLs for expiration. Instead, the leaseDuration is a hint for how often consumers should check back for a new value. This is commonly displayed as refreshInterval instead of leaseDuration to clarify this in output. If provided a key of ttl, the KV secrets engine will utilize this value as the lease duration: Even with a ttl set, the secrets engine never removes data on its own.The ttl key is merely advisory. When reading a value with a ttl, both the ttl key and the refresh interval will reflect the value:
        ///
        /// - Parameters:
        ///   - secret: The path of the secret to write.
        ///   - data: The secret data of the specified type.
        /// - Returns: A `VaultResponse` containing the written secret data.
        /// - Throws: An error if the request fails or the secret path is empty.
        public func write<T: Encodable>(secret: String, data: T) async throws -> VaultResponse<T> {
            guard !secret.isEmpty else {
                throw VaultError(error: "Secret must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/" + secret.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        /// Deletes the value at the specified path in Vault.
        ///
        /// - Parameter secret: The path of the secret to delete.
        /// - Throws: An error if the request fails or the secret path is empty.
        public func delete(secret: String) async throws {
            guard !secret.isEmpty else {
                throw VaultError(error: "Secret must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/" + secret.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Configuration for the KV v1 client.
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
            
            /// Initializes a new `Config` instance for the KV v1 client.
            ///
            /// - Parameters:
            ///   - mount: The mount path for the KV v1 engine (default is `kv-v1`).
            ///   - wrapTimeToLive: The wrap time to live for the requests (optional).
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? Vault.SecretEngines.MountType.keyValueV1.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    /// Builds a `KeyValueClient.V1` with the specified configuration.
    ///
    /// - Parameter config: The `KeyValueClient.V1.Config` instance.
    /// - Returns: A new `KeyValueClient.V1` instance.
    func buildKeyValueClientV1(config: KeyValueClient.V1.Config) -> KeyValueClient.V1 {
        .init(config: config, client: client)
    }
}

public extension Vault.SecretEngines {
    /// A namespace for KeyValue clients.
    enum KeyValueClient {}
}
