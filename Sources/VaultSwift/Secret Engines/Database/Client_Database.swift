import Foundation

public extension Vault.SecretEngines {
    /// A client for interacting with the Vault Database secret engine.
    struct DatabaseClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        
        /// Initializes a new `DatabaseClient` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the Database client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
        
        /// Initializes a new `DatabaseClient` instance with the specified configuration and Vault client.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the Database client.
        ///   - client: The `Vault.Client` instance.
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// Writes a connection configuration to the Database engine.
        ///
        /// - Parameters:
        ///   - connection: The name of the connection.
        ///   - config: The `ConnectionConfigRequest` instance containing the connection configuration.
        /// - Throws: An error if the request fails.
        public func write(connection: String, config: ConnectionConfigRequest) async throws {
            try await client.makeCall(path: self.config.mount + "/config/" + connection.trim(), httpMethod: .post, request: config, wrapTimeToLive: nil)
        }
        
        /// Retrieves a connection configuration from the Database engine.
        ///
        /// - Parameter connection: The name of the connection.
        /// - Returns: A `VaultResponse` containing the connection configuration.
        /// - Throws: An error if the request fails or the connection name is empty.
        public func get(connection: String) async throws -> VaultResponse<ConnectionConfigResponse> {
            guard !connection.isEmpty else {
                throw VaultError(error: "Connection must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/config/" + connection.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Retrieves all connection configurations from the Database engine.
        ///
        /// - Returns: A `VaultResponse` containing the keys of all connections.
        /// - Throws: An error if the request fails.
        public func getAllConnections() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/config?list=true", httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Deletes a connection configuration from the Database engine.
        ///
        /// - Parameter connection: The name of the connection to delete.
        /// - Throws: An error if the request fails.
        public func delete(connection: String) async throws {
            try await client.makeCall(path: config.mount + "/config/" + connection.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// This endpoint closes a connection and it's underlying plugin and restarts it
        /// with the configuration stored in the barrier.
        ///
        /// - Parameter connection: The name of the connection to reset.
        /// - Throws: An error if the request fails.
        public func reset(connection: String) async throws {
            try await client.makeCall(path: config.mount + "/reset/" + connection.trim(), httpMethod: .post, wrapTimeToLive: nil)
        }
        
        /// This endpoint performs the same operation as reset connection but for all connections
        /// that reference a specific plugin name.
        /// This can be useful to restart a specific plugin after it's been upgraded in the plugin catalog.
        ///
        /// - Parameter plugin: The name of the plugin to reload.
        /// - Throws: An error if the request fails.
        public func reload(plugin: String) async throws {
            try await client.makeCall(path: config.mount + "/reload/" + plugin.trim(), httpMethod: .post, wrapTimeToLive: nil)
        }
        
        /// This endpoint is used to rotate the "root" user credentials stored for the database connection.
        /// This user must have permissions to update its own password.
        /// Use caution: the root user's password will not be accessible once rotated so
        /// it is highly recommended that you create a user for Vault to utilize
        /// rather than using the actual root user.
        ///
        /// - Parameter connection: The name of the connection to rotate root credentials for.
        /// - Throws: An error if the request fails.
        public func rotateRootCredentialsFor(connection: String) async throws {
            try await client.makeCall(path: config.mount + "/rotate-root/" + connection.trim(), httpMethod: .post, wrapTimeToLive: nil)
        }
        
        /// Writes a role to the Database engine.
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
        
        /// Retrieves a role from the Database engine.
        ///
        /// - Parameter role: The name of the role.
        /// - Returns: A `VaultResponse` containing the role data.
        /// - Throws: An error if the request fails or the role name is empty.
        public func get(role: String) async throws -> VaultResponse<Role> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/roles/" + role.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint returns a list of available roles.
        /// Only the role names are returned, not any values.
        ///
        /// - Returns: A `VaultResponse` containing the keys of all roles.
        /// - Throws: An error if the request fails.
        public func getAllRoles() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/roles", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Deletes a role from the Database engine.
        ///
        /// - Parameter role: The name of the role to delete.
        /// - Throws: An error if the request fails or the role name is empty.
        public func delete(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/roles/" + role.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Retrieves credentials for a role from the Database engine.
        ///
        /// - Parameter role: The name of the role to retrieve credentials for.
        /// - Returns: A `VaultResponse` containing the user credentials.
        /// - Throws: An error if the request fails or the role name is empty.
        public func getCredentialsFor(role: String) async throws -> VaultResponse<Vault.UserCredentials> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/creds/" + role.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint creates or updates a static role definition.
        /// Static Roles are a 1-to-1 mapping of a Vault Role to a user in a database which are automatically
        /// rotated based on the configured rotationPeriod.
        /// Not all databases support Static Roles, please see the database-specific documentation.
        ///
        /// - Parameters:
        ///   - staticRole: The name of the static role.
        ///   - data: The `StaticRole` instance containing the static role data.
        /// - Throws: An error if the request fails or the static role name is empty.
        public func write(staticRole: String, data: StaticRole) async throws {
            guard !staticRole.isEmpty else {
                throw VaultError(error: "Static Role must not be empty")
            }
            
            try await client.makeCall(path: self.config.mount + "/static-roles/" + staticRole.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        /// Retrieves a static role from the Database engine.
        ///
        /// - Parameter staticRole: The name of the static role.
        /// - Returns: A `VaultResponse` containing the static role data.
        /// - Throws: An error if the request fails or the static role name is empty.
        public func get(staticRole: String) async throws -> VaultResponse<StaticRole> {
            guard !staticRole.isEmpty else {
                throw VaultError(error: "Static Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/static-roles/" + staticRole.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint returns a list of available static roles.
        /// Only the role names are returned, not any values.
        ///
        /// - Returns: A `VaultResponse` containing the keys of all static roles.
        /// - Throws: An error if the request fails.
        public func getAllStaticRoles() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/static-roles", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Deletes a static role from the Database engine.
        ///
        /// - Parameter staticRole: The name of the static role to delete.
        /// - Throws: An error if the request fails or the static role name is empty.
        public func delete(staticRole: String) async throws {
            guard !staticRole.isEmpty else {
                throw VaultError(error: "Static Role must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/static-roles/" + staticRole.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Retrieves static credentials for a role from the Database engine.
        ///
        /// - Parameter role: The name of the role to retrieve static credentials for.
        /// - Returns: A `VaultResponse` containing the static credentials.
        /// - Throws: An error if the request fails or the role name is empty.
        public func getStaticCredentialsFor(role: String) async throws -> VaultResponse<StaticCredentials> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/static-creds/" + role.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint is used to rotate the Static Role credentials stored for a given role name.
        /// While Static Roles are rotated automatically by Vault at configured rotation periods,
        /// users can use this endpoint to manually trigger a rotation to change the stored password and
        /// reset the TTL of the Static Role's password.
        ///
        /// - Parameter role: The name of the role to rotate static credentials for.
        /// - Throws: An error if the request fails or the role name is empty.
        public func rotateStaticCredentialsFor(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: self.config.mount + "/rotate-roles/" + role.trim(), httpMethod: .post, wrapTimeToLive: nil)
        }
        
        /// Configuration for the Database client.
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
            
            /// Initializes a new `Config` instance for the Database client.
            ///
            /// - Parameters:
            ///   - mount: The mount path for the Database engine (default is `database`).
            ///   - wrapTimeToLive: The wrap time to live for the requests (optional).
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.database.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    /// Builds a `DatabaseClient` with the specified configuration.
    ///
    /// - Parameter config: The `DatabaseClient.Config` instance.
    /// - Returns: A new `DatabaseClient` instance.
    func buildDatabaseClient(config: DatabaseClient.Config) -> DatabaseClient {
        .init(config: config, client: client)
    }
}
