import Foundation

public extension Vault.SecretEngines {
    /// A client for interacting with the Vault Active Directory secret engine.
    struct ActiveDirectoryClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        
        /// Initializes a new `ActiveDirectoryClient` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the Active Directory client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
        
        /// Initializes a new `ActiveDirectoryClient` instance with the specified configuration and Vault client.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the Active Directory client.
        ///   - client: The `Vault.Client` instance.
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// The config endpoint configures the LDAP connection and binding parameters,
        /// as well as the password rotation configuration.
        /// At present, this endpoint does not confirm that the provided AD credentials are
        /// valid AD credentials with proper permissions.
        ///
        /// - Parameter connectionConfig: The `ConnectionConfig` instance containing the connection configuration.
        /// - Throws: An error if the request fails.
        public func write(connectionConfig: ConnectionConfig) async throws {
            try await client.makeCall(path: self.config.mount + "/config", httpMethod: .post, request: connectionConfig, wrapTimeToLive: nil)
        }
        
        /// Retrieves the connection configuration from the Active Directory engine.
        ///
        /// - Returns: A `VaultResponse` containing the connection configuration.
        /// - Throws: An error if the request fails.
        public func getConnectionConfig() async throws -> VaultResponse<ConnectionConfig> {
            try await client.makeCall(path: config.mount + "/config", httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Deletes the connection configuration from the Active Directory engine.
        ///
        /// - Throws: An error if the request fails.
        public func deleteConnectionConfig() async throws {
            try await client.makeCall(path: config.mount + "/config", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Writes a role for Vault to manage the passwords for individual service accounts.
        /// When adding a role, Vault verifies its associated service account exists.
        ///
        /// - Parameters:
        ///   - role: The name of the role.
        ///   - data: The `RoleRequest` instance containing the role data.
        /// - Throws: An error if the request fails or the role name is empty.
        public func write(role: String, data: RoleRequest) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/roles/" + role.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        /// Retrieves a role from the Active Directory engine.
        ///
        /// - Parameter role: The name of the role.
        /// - Returns: A `VaultResponse` containing the role data.
        /// - Throws: An error if the request fails or the role name is empty.
        public func get(role: String) async throws -> VaultResponse<RoleResponse> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/roles/" + role.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Retrieves all roles from the Active Directory engine.
        ///
        /// - Returns: A `VaultResponse` containing the keys of all roles.
        /// - Throws: An error if the request fails.
        public func getAllRoles() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/roles", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Deletes a role from the Active Directory engine.
        ///
        /// - Parameter role: The name of the role to delete.
        /// - Throws: An error if the request fails or the role name is empty.
        public func delete(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/roles/" + role.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Retrieves credentials for a role from the Active Directory engine.
        ///
        /// - Parameter role: The name of the role to retrieve credentials for.
        /// - Returns: A `VaultResponse` containing the credentials.
        /// - Throws: An error if the request fails or the role name is empty.
        public func getCredentialsFor(role: String) async throws -> VaultResponse<Credentials> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/creds/" + role.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Rotates the root credentials for the Active Directory engine.
        ///
        /// - Returns: A `VaultResponse` containing the response for the rotation request.
        /// - Throws: An error if the request fails.
        public func rotateRootCredentials<T: Decodable & Sendable>() async throws -> VaultResponse<T> {
            try await client.makeCall(path: config.mount + "/rotate-root", httpMethod: .post, wrapTimeToLive: nil)
        }
        
        /// Retrieves the root credentials from the Active Directory engine.
        ///
        /// - Returns: A `VaultResponse` containing the root credentials.
        /// - Throws: An error if the request fails.
        public func getRootCredentials<T: Decodable & Sendable>() async throws -> VaultResponse<T> {
            try await client.makeCall(path: config.mount + "/rotate-root", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Rotates the credentials for a role in the Active Directory engine.
        ///
        /// - Parameter role: The name of the role to rotate credentials for.
        /// - Returns: A `VaultResponse` containing the response for the rotation request.
        /// - Throws: An error if the request fails or the role name is empty.
        public func rotateCredentialsFor<T: Decodable & Sendable>(role: String) async throws -> VaultResponse<T> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/rotate-role/" + role.trim(), httpMethod: .post, wrapTimeToLive: nil)
        }
        
        /// Configuration for the Active Directory client.
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
            
            /// Initializes a new `Config` instance for the Active Directory client.
            ///
            /// - Parameters:
            ///   - mount: The mount path for the Active Directory engine (default is `ad`).
            ///   - wrapTimeToLive: The wrap time to live for the requests (optional).
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.activeDirectory.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    /// Builds an `ActiveDirectoryClient` with the specified configuration.
    ///
    /// - Parameter config: The `ActiveDirectoryClient.Config` instance.
    /// - Returns: A new `ActiveDirectoryClient` instance.
    func buildActiveDirectoryClient(config: ActiveDirectoryClient.Config) -> ActiveDirectoryClient {
        .init(config: config, client: client)
    }
}
