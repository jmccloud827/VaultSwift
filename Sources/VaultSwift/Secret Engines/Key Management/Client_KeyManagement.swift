import Foundation

public extension Vault.SecretEngines {
    /// A client for interacting with the Vault Key Management secret engine.
    struct KeyManagementClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        
        /// Initializes a new `KeyManagementClient` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the Key Management client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
        
        /// Initializes a new `KeyManagementClient` instance with the specified configuration and Vault client.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the Key Management client.
        ///   - client: The `Vault.Client` instance.
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// Reads information about a named key.
        /// The keys object will hold information regarding each key version.
        /// Different information will be returned depending on the key type.
        /// For example, an asymmetric key will return its public key in a standard format for the type.
        ///
        /// - Parameter key: The name of the key to retrieve.
        /// - Returns: A `VaultResponse` containing the key data.
        /// - Throws: An error if the request fails or the key name is empty.
        public func get<T: Decodable & Sendable>(key: String) async throws -> VaultResponse<Key<T>> {
            guard !key.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/key/" + key.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Reads information about a key that's been distributed to a KMS provider.
        ///
        /// - Parameters:
        ///   - key: The name of the key to retrieve.
        ///   - kms: The name of the KMS.
        /// - Returns: A `VaultResponse` containing the key data.
        /// - Throws: An error if the request fails, the key name is empty, or the KMS name is empty.
        public func get(key: String, inKMS kms: String) async throws -> VaultResponse<KMSKey> {
            guard !key.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
            
            guard !kms.isEmpty else {
                throw VaultError(error: "KMS must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/kms/" + kms.trim() + "/key/" + key.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Configuration for the Key Management client.
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
            
            /// Initializes a new `Config` instance for the Key Management client.
            ///
            /// - Parameters:
            ///   - mount: The mount path for the Key Management engine (default is `key-management`).
            ///   - wrapTimeToLive: The wrap time to live for the requests (optional).
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.keyManagement.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    /// Builds a `KeyManagementClient` with the specified configuration.
    ///
    /// - Parameter config: The `KeyManagementClient.Config` instance.
    /// - Returns: A new `KeyManagementClient` instance.
    func buildKeyManagementClient(config: KeyManagementClient.Config) -> KeyManagementClient {
        .init(config: config, client: client)
    }
}
