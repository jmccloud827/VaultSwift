import Foundation

public extension Vault.SecretEngines {
    /// A client for interacting with the Vault Consul secret engine.
    struct ConsulClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        
        /// Initializes a new `ConsulClient` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the Consul client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
        
        /// Initializes a new `ConsulClient` instance with the specified configuration and Vault client.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the Consul client.
        ///   - client: The `Vault.Client` instance.
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// This endpoint configures the access information for Consul.
        /// This access information is used so that Vault can communicate with Consul and generate Consul tokens.
        ///
        /// - Parameter access: The `AccessConfig` instance containing the access configuration.
        /// - Throws: An error if the request fails.
        public func write(access: AccessConfig) async throws {
            try await client.makeCall(path: self.config.mount + "/config/access", httpMethod: .post, request: access, wrapTimeToLive: nil)
        }
        
        /// The role endpoint configures a consul role definition.
        ///
        /// - Parameters:
        ///   - role: The name of the role.
        ///   - data: The `Role` instance containing the role data.
        /// - Throws: An error if the request fails or the role name is empty.
        public func write(role: String, data: Role) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: self.config.mount + "/roles/" + role.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        /// This endpoint queries an existing role by the given name.
        ///
        /// - Parameter role: The name of the role.
        /// - Returns: A `VaultResponse` containing the role data.
        /// - Throws: An error if the request fails or the role name is empty.
        public func get(role: String) async throws -> VaultResponse<Role> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: self.config.mount + "/roles/" + role.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Retrieves all roles from the Consul engine.
        ///
        /// - Returns: A `VaultResponse` containing the keys of all roles.
        /// - Throws: An error if the request fails.
        public func getAllRoles() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: self.config.mount + "/roles", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Deletes a role from the Consul engine.
        ///
        /// - Parameter role: The name of the role to delete.
        /// - Throws: An error if the request fails or the role name is empty.
        public func delete(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: self.config.mount + "/roles/" + role.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Retrieves credentials for a role from the Consul engine.
        ///
        /// - Parameter role: The name of the role to retrieve credentials for.
        /// - Returns: A `VaultResponse` containing the credentials.
        /// - Throws: An error if the request fails or the role name is empty.
        public func getCredentialsFor(role: String) async throws -> VaultResponse<Credentials> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: self.config.mount + "/creds/" + role.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Configuration for the Consul client.
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
            
            /// Initializes a new `Config` instance for the Consul client.
            ///
            /// - Parameters:
            ///   - mount: The mount path for the Consul engine (default is `consul`).
            ///   - wrapTimeToLive: The wrap time to live for the requests (optional).
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.consul.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    /// Builds a `ConsulClient` with the specified configuration.
    ///
    /// - Parameter config: The `ConsulClient.Config` instance.
    /// - Returns: A new `ConsulClient` instance.
    func buildConsulClient(config: ConsulClient.Config) -> ConsulClient {
        .init(config: config, client: client)
    }
}
