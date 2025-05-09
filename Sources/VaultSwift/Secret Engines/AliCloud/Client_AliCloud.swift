import Foundation

public extension Vault.SecretEngines {
    /// A client for interacting with the Vault AliCloud secret engine.
    struct AliCloudClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        
        /// Initializes a new `AliCloudClient` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the AliCloud client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
        
        /// Initializes a new `AliCloudClient` instance with the specified configuration and Vault client.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the AliCloud client.
        ///   - client: The `Vault.Client` instance.
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// This endpoint configures the root RAM credentials to communicate with AliCloud.
        /// To use instance metadata, leave the static credential configuration unset.
        ///
        /// - Parameter rootCredentials: The `RootCredentialsConfig` instance containing the root credentials configuration.
        /// - Throws: An error if the request fails.
        public func write(rootCredentials: RootCredentialsConfig) async throws {
            try await client.makeCall(path: self.config.mount + "/config", httpMethod: .post, request: rootCredentials, wrapTimeToLive: nil)
        }
        
        /// Retrieves the root credentials configuration from the AliCloud engine.
        ///
        /// - Returns: A `VaultResponse` containing the root credentials configuration.
        /// - Throws: An error if the request fails.
        public func getRootCredentials() async throws -> VaultResponse<RootCredentialsConfig> {
            try await client.makeCall(path: self.config.mount + "/config", httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Writes a role to the AliCloud engine.
        ///
        /// - Parameters:
        ///   - role: The name of the role.
        ///   - data: The `RoleRequest` instance containing the role data.
        /// - Throws: An error if the request fails or the role name is empty.
        public func write(role: String, data: RoleRequest) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: self.config.mount + "/role/" + role.trim(), httpMethod: .get, request: data, wrapTimeToLive: nil)
        }
        
        /// Retrieves a role from the AliCloud engine.
        ///
        /// - Parameter role: The name of the role.
        /// - Returns: A `VaultResponse` containing the role data.
        /// - Throws: An error if the request fails or the role name is empty.
        public func get(role: String) async throws -> VaultResponse<RoleResponse> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: self.config.mount + "/role/" + role.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Retrieves all roles from the AliCloud engine.
        ///
        /// - Returns: A `VaultResponse` containing the keys of all roles.
        /// - Throws: An error if the request fails.
        public func getAllRoles() async throws -> VaultResponse<[String: Vault.Keys]> {
            try await client.makeCall(path: self.config.mount + "/role", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Deletes a role from the AliCloud engine.
        ///
        /// - Parameter role: The name of the role to delete.
        /// - Throws: An error if the request fails or the role name is empty.
        public func delete(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: self.config.mount + "/role/" + role.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Retrieves credentials for a role from the AliCloud engine.
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
        
        /// Configuration for the AliCloud client.
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
            
            /// Initializes a new `Config` instance for the AliCloud client.
            ///
            /// - Parameters:
            ///   - mount: The mount path for the AliCloud engine (default is `alicloud`).
            ///   - wrapTimeToLive: The wrap time to live for the requests (optional).
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.aliCloud.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    /// Builds an `AliCloudClient` with the specified configuration.
    ///
    /// - Parameter config: The `AliCloudClient.Config` instance.
    /// - Returns: A new `AliCloudClient` instance.
    func buildAliCloudClient(config: AliCloudClient.Config) -> AliCloudClient {
        .init(config: config, client: client)
    }
}
