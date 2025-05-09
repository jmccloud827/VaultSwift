import Foundation

public extension Vault.SecretEngines.KeyValueClient {
    /// A client for interacting with the Vault Key-Value (KV) version 2 secret engine.
    struct V2: BackendClient {
        public let config: Config
        private let client: Vault.Client
        
        /// Initializes a new `V2` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the KV v2 client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
        
        /// Initializes a new `V2` instance with the specified configuration and Vault client.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the KV v2 client.
        ///   - client: The `Vault.Client` instance.
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// This path configures backend level settings that are applied to every key in the key-value store.
        ///
        /// - Parameter config: The `ConfigModel` instance containing the configuration data.
        /// - Throws: An error if the request fails.
        public func write(config: ConfigModel) async throws {
            try await client.makeCall(path: self.config.mount + "/config", httpMethod: .post, request: config, wrapTimeToLive: nil)
        }
        
        /// Reads the common config for all keys.
        ///
        /// - Returns: A `VaultResponse` containing the configuration data.
        /// - Throws: An error if the request fails.
        public func getConfig() async throws -> VaultResponse<ConfigModel> {
            try await client.makeCall(path: self.config.mount + "/config", httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Retrieves the secret at the specified location.
        ///
        /// - Parameter secret: The path of the secret to retrieve.
        /// - Returns: A `VaultResponse` containing the secret data.
        /// - Throws: An error if the request fails or the secret path is empty.
        public func get(secret: String) async throws -> VaultResponse<Secret<[String: String]>> {
            guard !secret.isEmpty else {
                throw VaultError(error: "Secret must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/data/" + secret.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Retrieves the secret at the specified location.
        ///
        /// - Parameter secret: The path of the secret to retrieve.
        /// - Returns: A `VaultResponse` containing the secret data of the specified type.
        /// - Throws: An error if the request fails or the secret path is empty.
        public func get<T: Decodable>(secret: String) async throws -> VaultResponse<Secret<T>> {
            guard !secret.isEmpty else {
                throw VaultError(error: "Secret must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/data/" + secret.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Stores a secret at the specified location. If the value does not yet exist, the calling token must have an ACL policy granting the create capability.
        /// If the value already exists, the calling token must have an ACL policy granting the update capability.
        ///
        /// - Remark: Unlike other secrets engines, the KV secrets engine does not enforce TTLs for expiration. Instead, the leaseDuration is a hint for how often consumers should check back for a new value. This is commonly displayed as refreshInterval instead of leaseDuration to clarify this in output. f provided a key of ttl, the KV secrets engine will utilize this value as the lease duration: Even with a ttl set, the secrets engine never removes data on its own.The ttl key is merely advisory. When reading a value with a ttl, both the ttl key and the refresh interval will reflect the value.
        ///
        /// - Parameters:
        ///   - secret: The path of the secret to write.
        ///   - data: The `SecretRequest` instance containing the secret data.
        /// - Returns: A `VaultResponse` containing the metadata of the written secret.
        /// - Throws: An error if the request fails or the secret path is empty.
        public func write(secret: String, data: SecretRequest<some Encodable>) async throws -> VaultResponse<Metadata> {
            guard !secret.isEmpty else {
                throw VaultError(error: "Secret must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/data/" + secret.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        /// Writes the data to the given path in the K/V v2 secrets engine.
        /// The data can be of any type.
        /// Unlike the write(secret: String) method, the patch command combines the change with existing data
        /// instead of replacing them.
        /// Therefore, this command makes it easy to make a partial updates to an existing data.
        ///
        /// - Parameters:
        ///   - secret: The path of the secret to update.
        ///   - data: The `SecretRequest` instance containing the secret data.
        /// - Returns: A `VaultResponse` containing the metadata of the updated secret.
        /// - Throws: An error if the request fails or the secret path is empty.
        public func update(secret: String, data: SecretRequest<some Encodable>) async throws -> VaultResponse<Metadata> {
            guard !secret.isEmpty else {
                throw VaultError(error: "Secret must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/data/" + secret.trim(), httpMethod: .patch, request: data, wrapTimeToLive: nil)
        }
        
        /// This endpoint provides the subkeys within a secret entry that
        /// exists at the requested path.The secret entry at this path will be
        /// retrieved and stripped of all data by replacing underlying values
        /// of leaf keys (i.e. non-map keys or map keys with no underlying
        /// subkeys) with null.
        ///
        /// - Parameters:
        ///   - path: The path of the secret to retrieve subkeys for.
        ///   - version: The version to return. If not set the latest version is returned.
        ///   - depth: Specifies the deepest nesting level to provide in the output. The default value 0 will not impose any limit. If non-zero, keys that reside at the specified depth value will be artificially treated as leaves and will thus be null even if further underlying subkeys exist.
        /// - Returns: A `VaultResponse` containing the subkeys.
        /// - Throws: An error if the request fails or the path is empty.
        public func getSecretSubkeysFrom<T: Decodable & Sendable>(path: String, version: Int? = nil, depth: Int? = nil) async throws -> VaultResponse<Subkeys<T>> {
            guard !path.isEmpty else {
                throw VaultError(error: "Path must not be empty")
            }
            
            let queryParameters = "?version=\(version ?? 0)&depth=\(depth ?? 0)"
            
            return try await client.makeCall(path: config.mount + "/subkeys/" + path.trim() + queryParameters, httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint issues a soft delete of the secret's latest version at the specified location.
        /// This marks the version as deleted and will stop it from being returned from reads,
        /// but the underlying data will not be removed. A delete can be undone using the Undelete method.
        ///
        /// - Parameter secret: The path of the secret to delete.
        /// - Throws: An error if the request fails or the secret path is empty.
        public func delete(secret: String) async throws {
            guard !secret.isEmpty else {
                throw VaultError(error: "Secret must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/data/" + secret.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// This endpoint issues a soft delete of the secret's latest version at the specified location.
        /// This marks the version as deleted and will stop it from being returned from reads,
        /// but the underlying data will not be removed. A delete can be undone using the Undelete method.
        ///
        /// - Parameters:
        ///   - secret: The path of the secret to delete versions for.
        ///   - versions: The versions of the secret to delete.
        /// - Throws: An error if the request fails, the secret path is empty, or no versions are provided.
        public func delete(secret: String, versions: [Int]) async throws {
            guard !secret.isEmpty else {
                throw VaultError(error: "Secret must not be empty")
            }
            
            guard !versions.isEmpty else {
                throw VaultError(error: "At least one version must be provided")
            }
            
            try await client.makeCall(path: config.mount + "/delete/" + secret.trim(), httpMethod: .post, request: ["versions": versions], wrapTimeToLive: nil)
        }
        
        /// Undeletes the data for the provided version and path in the key-value store.
        /// This restores the data, allowing it to be returned on get requests.
        ///
        /// - Parameters:
        ///   - secret: The path of the secret to undelete versions for.
        ///   - versions: The versions of the secret to undelete.
        /// - Throws: An error if the request fails, the secret path is empty, or no versions are provided.
        public func undelete(secret: String, versions: [Int]) async throws {
            guard !secret.isEmpty else {
                throw VaultError(error: "Secret must not be empty")
            }
            
            guard !versions.isEmpty else {
                throw VaultError(error: "At least one version must be provided")
            }
            
            try await client.makeCall(path: config.mount + "/undelete/" + secret.trim(), httpMethod: .post, request: ["versions": versions], wrapTimeToLive: nil)
        }
        
        /// Permanently removes the specified version data for the provided key and version numbers from the key-value store.
        ///
        /// - Parameters:
        ///   - secret: The path of the secret to destroy versions for.
        ///   - versions: The versions of the secret to destroy.
        /// - Throws: An error if the request fails, the secret path is empty, or no versions are provided.
        public func destroy(secret: String, versions: [Int]) async throws {
            guard !secret.isEmpty else {
                throw VaultError(error: "Secret must not be empty")
            }
            
            guard !versions.isEmpty else {
                throw VaultError(error: "At least one version must be provided")
            }
            
            try await client.makeCall(path: config.mount + "/destroy/" + secret.trim(), httpMethod: .post, request: ["versions": versions], wrapTimeToLive: nil)
        }
        
        /// Retrieves the secret location path entries at the specified location.
        /// Folders are suffixed with /. The input must be a folder; list on a file will not return a value.
        /// The values themselves are not accessible via this API.
        ///
        /// - Parameter path: The location path where the secret needs to be read from. Can be empty string or null, if you want to list all secrets on the mount point.
        /// - Returns: A `VaultResponse` containing the keys.
        /// - Throws: An error if the request fails.
        public func listSecretPathsFrom(path: String) async throws -> VaultResponse<Vault.Keys> {
            let queryParameters = "?list=true"
            
            return try await client.makeCall(path: config.mount + "/metadata/" + path.trim() + queryParameters, httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Retrieves the secret metadata at the specified location.
        ///
        /// - Parameter secret: The path of the secret to retrieve metadata for.
        /// - Returns: A `VaultResponse` containing the metadata.
        /// - Throws: An error if the request fails or the secret path is empty.
        public func getMetadataFor(secret: String) async throws -> VaultResponse<Metadata> {
            guard !secret.isEmpty else {
                throw VaultError(error: "Secret must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/metadata/" + secret.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Creates or updates the metadata of a secret at the specified location in
        /// the K/V v2 secrets engine.
        /// It does not create a new version.
        ///
        /// - Parameters:
        ///   - secret: The path of the secret to write metadata for.
        ///   - metadata: The `SecretMetadataRequest` instance containing the metadata.
        /// - Returns: A `VaultResponse` containing the full metadata.
        /// - Throws: An error if the request fails or the secret path is empty.
        public func write(secret: String, metadata: SecretMetadataRequest) async throws -> VaultResponse<FullMetadata> {
            guard !secret.isEmpty else {
                throw VaultError(error: "Secret must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/metadata/" + secret.trim(), httpMethod: .post, request: metadata, wrapTimeToLive: nil)
        }
        
        /// Patch the metadata of a secret at specified location in the K/V v2 secrets engine.
        /// The patch command combines the change with existing custom metadata instead of replacing them.
        /// Therefore, this command makes it easy to make a partial updates to an existing metadata.
        ///
        /// - Parameters:
        ///   - secret: The path of the secret to update metadata for.
        ///   - metadata: The `SecretMetadataRequest` instance containing the metadata.
        /// - Returns: A `VaultResponse` containing the full metadata.
        /// - Throws: An error if the request fails or the secret path is empty.
        public func update(secret: String, metadata: SecretMetadataRequest) async throws -> VaultResponse<FullMetadata> {
            guard !secret.isEmpty else {
                throw VaultError(error: "Secret must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/metadata/" + secret.trim(), httpMethod: .patch, request: metadata, wrapTimeToLive: nil)
        }
        
        /// This endpoint permanently deletes the key metadata and all version data for the specified key.
        /// All version history will be removed.
        ///
        /// - Parameter secret: The path of the secret to delete metadata for.
        /// - Returns: A `VaultResponse` containing the full metadata.
        /// - Throws: An error if the request fails or the secret path is empty.
        public func deleteMetadataFor(secret: String) async throws -> VaultResponse<FullMetadata> {
            guard !secret.isEmpty else {
                throw VaultError(error: "Secret must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/metadata/" + secret.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Configuration for the KV v2 client.
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
            
            /// Initializes a new `Config` instance for the KV v2 client.
            ///
            /// - Parameters:
            ///   - mount: The mount path for the KV v2 engine (default is `kv-v2`).
            ///   - wrapTimeToLive: The wrap time to live for the requests (optional).
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? Vault.SecretEngines.MountType.keyValueV2.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    /// Builds a `KeyValueClient.V2` with the specified configuration.
    ///
    /// - Parameter config: The `KeyValueClient.V2.Config` instance.
    /// - Returns: A new `KeyValueClient.V2` instance.
    func buildKeyValueClientV2(config: KeyValueClient.V2.Config) -> KeyValueClient.V2 {
        .init(config: config, client: client)
    }
}
