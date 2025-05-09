import Foundation

public extension Vault.AuthProviders {
    /// A client for interacting with the Vault JWT (JSON Web Token) authentication method.
    struct JWTClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        private let basePath = "v1/auth"
        
        /// Initializes a new `JWTClient` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the JWT client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.config = config
            self.client = .init(config: vaultConfig)
        }
        
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// Obtain an authorization URL from Vault to start an OIDC login flow.
        ///
        /// - Parameters:
        ///   - redirectUri: Path to the callback to complete the login. This will be of the form, "https://.../oidc/callback" where the leading portion is dependent on your Vault server location, port, and the mount of the JWT plugin. This must be configured with Vault and the provider.
        ///   - roleName: Name of the role against which the login is being attempted. Defaults to configured defaultRole if not provided.
        ///   - clientNonce: Optional client-provided nonce that must match the client_nonce value provided during a subsequent request to the callback API.
        /// - Returns: A `VaultResponse` containing the authentication URL response.
        /// - Throws: An error if the request fails or the redirect URI is empty.
        public func getOIDCAuthURL(redirectUri: String, roleName: String? = nil, clientNonce: String? = nil) async throws -> VaultResponse<AuthURLResponse> {
            guard !redirectUri.isEmpty else {
                throw VaultError(error: "Redirect URI must not be empty")
            }
            
            var request = ["redirect_uri": redirectUri]
            
            if let roleName {
                request["role"] = roleName
            }
            
            if let clientNonce {
                request["client_nonce"] = clientNonce
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/oidc/auth_url", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Exchange an authorization code for an OIDC ID Token.
        /// The ID token will be further validated against any bound claims, and if valid a Vault token will be returned.
        ///
        /// - Parameters:
        ///   - state: Opaque state ID that is part of the Authorization URL and will be included in the the redirect following successful authentication on the provider.
        ///   - nonce: Opaque nonce that is part of the Authorization URL and will be included in the the redirect following successful authentication on the provider.
        ///   - code: Provider-generated authorization code that Vault will exchange for an ID token.
        ///   - clientNonce: Optional client-provided nonce that must match the client_nonce value provided during the prior request to the auth API.
        /// - Returns: A `VaultResponse` containing the authentication response.
        /// - Throws: An error if the request fails or any of the required parameters are empty.
        public func getOIDCAuthURL(state: String, nonce: String, code: String, clientNonce: String? = nil) async throws -> VaultResponse<AuthResponse> {
            guard !state.isEmpty else {
                throw VaultError(error: "State must not be empty")
            }
            
            guard !nonce.isEmpty else {
                throw VaultError(error: "Nonce must not be empty")
            }
            
            guard !code.isEmpty else {
                throw VaultError(error: "Code must not be empty")
            }
            
            var queryString = "state=\(state)&nonce=\(nonce)&code=\(code)"
            
            if let clientNonce {
                queryString += "&client_nonce=\(clientNonce)"
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/oidc/callback?" + queryString, httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Configuration for the JWT client.
        public struct Config {
            public let mount: String
            
            /// Initializes a new `Config` instance for the JWT client.
            ///
            /// - Parameter mount: The mount path for the JWT engine (default is `jwt`).
            public init(mount: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MethodType.jwt.rawValue)
            }
        }
    }
}

public extension Vault.AuthProviders {
    /// Builds a `JWTClient` with the specified configuration.
    ///
    /// - Parameter config: The `JWTClient.Config` instance.
    /// - Returns: A new `JWTClient` instance.
    func buildJWTClient(config: JWTClient.Config) -> JWTClient {
        .init(config: config, client: client)
    }
}
