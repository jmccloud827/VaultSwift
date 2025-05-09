import Foundation

public extension Vault.SecretEngines {
    /// A client for interacting with the Vault OpenLDAP secret engine.
    struct OpenLDAPClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        
        /// Initializes a new `OpenLDAPClient` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the OpenLDAP client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
        
        /// Initializes a new `OpenLDAPClient` instance with the specified configuration and Vault client.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the OpenLDAP client.
        ///   - client: The `Vault.Client` instance.
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// Writes a dynamic role.
        ///
        /// - Parameters:
        ///   - dynamicRole: The name of the dynamic role.
        ///   - data: The `DynamicRole` instance containing the role data.
        /// - Throws: An error if the request fails or the dynamic role is empty.
        public func write(dynamicRole: String, data: DynamicRole) async throws {
            guard !dynamicRole.isEmpty else {
                throw VaultError(error: "Dynamic Role must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/role/" + dynamicRole.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        /// Retrieves a dynamic role.
        ///
        /// - Parameter dynamicRole: The name of the dynamic role.
        /// - Returns: A `VaultResponse` containing the dynamic role.
        /// - Throws: An error if the request fails or the dynamic role is empty.
        public func get(dynamicRole: String) async throws -> VaultResponse<DynamicRole> {
            guard !dynamicRole.isEmpty else {
                throw VaultError(error: "Dynamic Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/role/" + dynamicRole.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint returns a list of available roles.
        /// Only the role names are returned, not any values.
        ///
        /// - Returns: A `VaultResponse` containing all dynamic roles.
        /// - Throws: An error if the request fails.
        public func getAllDynamicRoles() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/role/", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Deletes a dynamic role.
        ///
        /// - Parameter dynamicRole: The name of the dynamic role.
        /// - Throws: An error if the request fails or the dynamic role is empty.
        public func delete(dynamicRole: String) async throws {
            guard !dynamicRole.isEmpty else {
                throw VaultError(error: "Dynamic Role must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/role/" + dynamicRole.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Retrieves credentials for the specified dynamic role.
        ///
        /// - Parameter dynamicRole: The name of the dynamic role.
        /// - Returns: A `VaultResponse` containing the dynamic role credentials.
        /// - Throws: An error if the request fails or the dynamic role is empty.
        public func getCredentialsFor(dynamicRole: String) async throws -> VaultResponse<DynamicRoleCredentials> {
            guard !dynamicRole.isEmpty else {
                throw VaultError(error: "Dynamic Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/creds/" + dynamicRole.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint creates or updates a static role definition.
        /// Static roles are a 1-to-1 mapping of a Vault Role to a user in the LDAP directory
        /// which are automatically rotated based on the configured rotationPeriod.
        ///
        /// - Parameters:
        ///   - staticRole: The name of the static role.
        ///   - data: The `StaticRole` instance containing the role data.
        /// - Throws: An error if the request fails or the static role is empty.
        public func write(staticRole: String, data: StaticRole) async throws {
            guard !staticRole.isEmpty else {
                throw VaultError(error: "Static Role must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/static-role/" + staticRole.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        /// Retrieves a static role.
        ///
        /// - Parameter staticRole: The name of the static role.
        /// - Returns: A `VaultResponse` containing the static role.
        /// - Throws: An error if the request fails or the static role is empty.
        public func get(staticRole: String) async throws -> VaultResponse<StaticRole> {
            guard !staticRole.isEmpty else {
                throw VaultError(error: "Static Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/static-role/" + staticRole.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint returns a list of available static roles.
        /// Only the role names are returned, not any values.
        ///
        /// - Returns: A `VaultResponse` containing all static roles.
        /// - Throws: An error if the request fails.
        public func getAllStaticRoles() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/static-role/", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Deletes a static role.
        ///
        /// - Parameter staticRole: The name of the static role.
        /// - Throws: An error if the request fails or the static role is empty.
        public func delete(staticRole: String) async throws {
            guard !staticRole.isEmpty else {
                throw VaultError(error: "Static Role must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/static-role/" + staticRole.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Retrieves credentials for the specified static role.
        ///
        /// - Parameter staticRole: The name of the static role.
        /// - Returns: A `VaultResponse` containing the static role credentials.
        /// - Throws: An error if the request fails or the static role is empty.
        public func getCredentialsFor(staticRole: String) async throws -> VaultResponse<StaticRoleCredentials> {
            guard !staticRole.isEmpty else {
                throw VaultError(error: "Static Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/static-cred/" + staticRole.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint is used to rotate the Static Role credentials stored for a given role name.
        /// While Static Roles are rotated automatically by Vault at configured rotation periods,
        /// users can use this endpoint to manually trigger a rotation to change the stored password and
        /// reset the TTL of a Static Role's password.
        ///
        /// - Parameter staticRole: The name of the static role.
        /// - Throws: An error if the request fails or the static role is empty.
        public func rotateCredentialsFor(staticRole: String) async throws {
            guard !staticRole.isEmpty else {
                throw VaultError(error: "Static Role must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/rotate-role/" + staticRole.trim(), httpMethod: .post, wrapTimeToLive: nil)
        }
        
        /// Configuration for the OpenLDAP client.
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
            
            /// Initializes a new `Config` instance for the OpenLDAP client.
            ///
            /// - Parameters:
            ///   - mount: The mount path for the OpenLDAP engine (default is `openldap`).
            ///   - wrapTimeToLive: The wrap time to live for the requests (optional).
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.openLDAP.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    /// Builds an `OpenLDAPClient` with the specified configuration.
    ///
    /// - Parameter config: The `OpenLDAPClient.Config` instance.
    /// - Returns: A new `OpenLDAPClient` instance.
    func buildOpenLDAPClient(config: OpenLDAPClient.Config) -> OpenLDAPClient {
        .init(config: config, client: client)
    }
}
