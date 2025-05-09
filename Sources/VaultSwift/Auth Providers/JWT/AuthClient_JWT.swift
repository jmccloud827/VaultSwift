import Foundation

public extension Vault.AuthProviders {
    struct JWTClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        private let basePath = "v1/auth"
        
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.config = config
            self.client = .init(config: vaultConfig)
        }
        
        init (config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
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
            
            return try await client.makeCall(path: basePath + config.mount + "/oidc/callback" + queryString, httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public struct Config {
            public let mount: String
                
            public init(mount: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MethodType.jwt.rawValue)
            }
        }
    }
}

public extension Vault.AuthProviders {
    func buildJWTClient(config: JWTClient.Config) -> JWTClient {
        .init(config: config, client: client)
    }
}
