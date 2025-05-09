import Foundation

public extension Vault.AuthProviders {
    /// A client for interacting with the Vault AliCloud authentication method.
    struct AliCloudClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        private let basePath = "v1/auth"
        
        /// Initializes a new `AliCloudClient` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the AliCloud client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.config = config
            self.client = .init(config: vaultConfig)
        }
        
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// This endpoint returns a list of available roles.
        /// Only the role names are returned, not any values.
        ///
        /// - Returns: A `VaultResponse` containing the keys of all roles.
        /// - Throws: An error if the request fails.
        public func getAllRoles() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: basePath + config.mount + "/role", httpMethod: .list, wrapTimeToLive: nil)
        }
        
        /// Registers a role.
        /// Only entities using the role registered using this endpoint will
        /// be able to perform the login operation.
        ///
        /// - Parameters:
        ///   - role: The name of the role.
        ///   - data: The data for the role.
        /// - Throws: An error if the request fails or the role name is empty.
        public func write(role: String, data: RoleRequest) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        /// Retrieves the data for a role.
        ///
        /// - Parameter role: The name of the role.
        /// - Returns: A `VaultResponse` containing the role data.
        /// - Throws: An error if the request fails or the role name is empty.
        public func get(role: String) async throws -> VaultResponse<RoleResponse> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Deletes a role.
        ///
        /// - Parameter role: The name of the role.
        /// - Throws: An error if the request fails or the role name is empty.
        public func delete(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Configuration for the AliCloud client.
        public struct Config {
            public let mount: String
            
            /// Initializes a new `Config` instance for the AliCloud client.
            ///
            /// - Parameter mount: The mount path for the AliCloud engine (default is `alicloud`).
            public init(mount: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MethodType.aliCloud.rawValue)
            }
        }
    }
}

public extension Vault.AuthProviders {
    /// Builds an `AliCloudClient` with the specified configuration.
    ///
    /// - Parameter config: The `AliCloudClient.Config` instance.
    /// - Returns: A new `AliCloudClient` instance.
    func buildAliCloudClient(config: AliCloudClient.Config) -> AliCloudClient {
        .init(config: config, client: client)
    }
}
