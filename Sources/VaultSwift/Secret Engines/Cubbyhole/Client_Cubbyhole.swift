import Foundation

public extension Vault.SecretEngines {
    /// A client for interacting with the Vault Cubbyhole secret engine.
    struct CubbyholeClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        
        /// Initializes a new `CubbyholeClient` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the Cubbyhole client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
        
        /// Initializes a new `CubbyholeClient` instance with the specified configuration and Vault client.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the Cubbyhole client.
        ///   - client: The `Vault.Client` instance.
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// Retrieves a secret from the Cubbyhole engine.
        ///
        /// - Parameter secret: The path of the secret to retrieve.
        /// - Returns: A `VaultResponse` containing the secret data.
        /// - Throws: An error if the request fails or the secret path is empty.
        public func get<T: Decodable & Sendable>(secret: String) async throws -> VaultResponse<T> {
            guard !secret.isEmpty else {
                throw VaultError(error: "Secret must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/" + secret.trim() + "/", httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Retrieves the secret location path entries at the specified location.
        /// Folders are suffixed with /. The input must be a folder; list on a file will not return a value.
        /// The values themselves are not accessible via this API.
        ///
        /// - Parameter path: The path to list secret paths from.
        /// - Returns: A `VaultResponse` containing the keys.
        /// - Throws: An error if the request fails.
        public func listSecretPathsFrom(path: String) async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/" + path.trim() + "/", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Writes a secret to the Cubbyhole engine.
        ///
        /// - Parameters:
        ///   - secret: The path of the secret to write.
        ///   - values: The secret data to write.
        /// - Throws: An error if the request fails or the secret path is empty.
        public func write(secret: String, values: some Encodable & Sendable) async throws {
            guard !secret.isEmpty else {
                throw VaultError(error: "Secret must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/" + secret.trim(), httpMethod: .post, request: values, wrapTimeToLive: nil)
        }
        
        /// Deletes a secret from the Cubbyhole engine.
        ///
        /// - Parameter secret: The path of the secret to delete.
        /// - Throws: An error if the request fails or the secret path is empty.
        public func delete(secret: String) async throws {
            guard !secret.isEmpty else {
                throw VaultError(error: "Secret must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/" + secret.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Configuration for the Cubbyhole client.
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
            
            /// Initializes a new `Config` instance for the Cubbyhole client.
            ///
            /// - Parameters:
            ///   - mount: The mount path for the Cubbyhole engine (default is `cubbyhole`).
            ///   - wrapTimeToLive: The wrap time to live for the requests (optional).
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.cubbyhole.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    /// Builds a `CubbyholeClient` with the specified configuration.
    ///
    /// - Parameter config: The `CubbyholeClient.Config` instance.
    /// - Returns: A new `CubbyholeClient` instance.
    func buildCubbyholeClient(config: CubbyholeClient.Config) -> CubbyholeClient {
        .init(config: config, client: client)
    }
}
