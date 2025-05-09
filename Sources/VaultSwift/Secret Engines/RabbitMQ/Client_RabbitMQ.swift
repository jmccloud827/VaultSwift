import Foundation

public extension Vault.SecretEngines {
    /// A client for interacting with the Vault RabbitMQ secret engine.
    struct RabbitMQClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        
        /// Initializes a new `RabbitMQClient` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the RabbitMQ client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
        
        /// Initializes a new `RabbitMQClient` instance with the specified configuration and Vault client.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the RabbitMQ client.
        ///   - client: The `Vault.Client` instance.
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// Generates a new set of dynamic credentials based on the named role.
        ///
        /// - Parameter role: The role to retrieve credentials for.
        /// - Returns: A `VaultResponse` containing the user credentials.
        /// - Throws: An error if the request fails or the role is empty.
        public func getCredentialsFor(role: String) async throws -> VaultResponse<Vault.UserCredentials> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/creds/" + role.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Configures the lease settings for generated credentials.
        ///
        /// - Parameter lease: The `Lease` instance containing the lease configuration.
        /// - Throws: An error if the request fails.
        public func write(lease: Lease) async throws {
            try await client.makeCall(path: config.mount + "/config/lease", httpMethod: .post, request: lease, wrapTimeToLive: nil)
        }
        
        /// Writes a role configuration.
        ///
        /// - Parameters:
        ///   - role: The name of the role.
        ///   - data: The `Role` instance containing the role configuration.
        /// - Throws: An error if the request fails or the role is empty.
        public func write(role: String, data: Role) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/roles/" + role.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        /// Retrieves a role configuration.
        ///
        /// - Parameter role: The name of the role.
        /// - Returns: A `VaultResponse` containing the role configuration.
        /// - Throws: An error if the request fails or the role is empty.
        public func get(role: String) async throws -> VaultResponse<Role> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/roles/" + role.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Deletes a role configuration.
        ///
        /// - Parameter role: The name of the role.
        /// - Throws: An error if the request fails or the role is empty.
        public func delete(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/roles/" + role.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Configuration for the RabbitMQ client.
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
            
            /// Initializes a new `Config` instance for the RabbitMQ client.
            ///
            /// - Parameters:
            ///   - mount: The mount path for the RabbitMQ engine (default is `rabbitmq`).
            ///   - wrapTimeToLive: The wrap time to live for the requests (optional).
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.rabbitMQ.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    /// Builds a `RabbitMQClient` with the specified configuration.
    ///
    /// - Parameter config: The `RabbitMQClient.Config` instance.
    /// - Returns: A new `RabbitMQClient` instance.
    func buildRabbitMQClient(config: RabbitMQClient.Config) -> RabbitMQClient {
        .init(config: config, client: client)
    }
}
