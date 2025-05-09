import Foundation

public extension Vault.AuthProviders {
    /// A client for interacting with the Vault Token authentication method.
    struct TokenClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        private let basePath = "v1/auth/token"
        
        /// Initializes a new `TokenClient` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the Token client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.config = config
            self.client = .init(config: vaultConfig)
        }
        
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// Creates a new token.
        /// Certain options are only available when called by a root token.
        /// If you are creating an orphaned token, a root token is not required to create an orphan token
        /// (otherwise set with the no_parent option).
        /// If used with a role name, the token will be created against the specified role name;
        /// this may override options set during this call.
        ///
        /// - Parameters:
        ///   - request: The `TokenRequest` instance containing the token request data.
        ///   - orphan: A Boolean value indicating whether to create an orphan token.
        /// - Returns: A `VaultResponse` containing the created token.
        /// - Throws: An error if the request fails.
        public func writeToken<T: Decodable & Sendable>(request: TokenRequest, orphan: Bool) async throws -> VaultResponse<T> {
            var suffix = orphan ? "create-orphan" : "create"
            
            if let roleName = request.roleName, !roleName.isEmpty {
                suffix += "/" + roleName.trim()
            }
            
            return try await client.makeCall(path: basePath + suffix, httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Retrieves the role configuration for the specified role.
        ///
        /// - Parameter role: The name of the role.
        /// - Returns: A `VaultResponse` containing the role configuration.
        /// - Throws: An error if the request fails or the role name is empty.
        public func getTokenRoleFor(role: String) async throws -> VaultResponse<TokenRoleResponse> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + "/roles/" + role.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Writes a role configuration for the specified role.
        ///
        /// - Parameters:
        ///   - role: The name of the role.
        ///   - request: The `TokenRoleRequest` instance containing the role configuration data.
        /// - Throws: An error if the request fails or the role name is empty.
        public func writeTokenRoleFor(role: String, request: TokenRoleRequest) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + "/roles/" + role.trim(), httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Deletes the role configuration for the specified role.
        ///
        /// - Parameter role: The name of the role.
        /// - Throws: An error if the request fails or the role name is empty.
        public func deleteTokenRoleFor(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + "/roles/" + role.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Retrieves all token roles.
        ///
        /// - Returns: A `VaultResponse` containing the keys of all token roles.
        /// - Throws: An error if the request fails.
        public func getAllTokenRoles() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: basePath + "/roles", httpMethod: .list, wrapTimeToLive: nil)
        }
        
        /// Looks up information about a specific token.
        ///
        /// - Parameter clientToken: The token to look up.
        /// - Returns: A `VaultResponse` containing the token information.
        /// - Throws: An error if the request fails or the token is empty.
        public func lookup(clientToken: String) async throws -> VaultResponse<LookupResponse> {
            guard !clientToken.isEmpty else {
                throw VaultError(error: "Client token must not be empty")
            }
            
            let request = ["token": clientToken]
            
            return try await client.makeCall(path: basePath + "/lookup", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Gets the calling client token information. i.e. the token used by the client as part of this call.
        ///
        /// - Returns: A `VaultResponse` containing the token information.
        /// - Throws: An error if the request fails.
        public func lookupSelf() async throws -> VaultResponse<LookupResponse> {
            try await client.makeCall(path: basePath + "/lookup-self", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Renews a lease associated with the calling token.
        /// This is used to prevent the expiration of a token, and the automatic revocation of it.
        /// Token renewal is possible only if there is a lease associated with it.
        ///
        /// - Parameter increment: The increment for the renewal (optional).
        /// - Returns: A `VaultResponse` containing the renewed token information.
        /// - Throws: An error if the request fails.
        public func renewSelf(increment: String? = nil) async throws -> VaultResponse<RenewSelfResponse> {
            var request: [String: String] = [:]
            
            if let increment {
                request["increment"] = increment
            }
            
            return try await client.makeCall(path: basePath + "/renew-self", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Revokes the calling client token and all child tokens.
        /// When the token is revoked, all secrets generated with it are also revoked.
        ///
        /// - Throws: An error if the request fails.
        public func revokeSelf() async throws {
            try await client.makeCall(path: basePath + "/revoke-self", httpMethod: .post, wrapTimeToLive: nil)
        }
        
        /// Configuration for the Token client.
        public struct Config {
            public init() {}
        }
    }
}

public extension Vault.AuthProviders {
    /// Builds a `TokenClient` with the specified configuration.
    ///
    /// - Parameter config: The `TokenClient.Config` instance.
    /// - Returns: A new `TokenClient` instance.
    func buildTokenClient(config: TokenClient.Config) -> TokenClient {
        .init(config: config, client: client)
    }
}
