import Foundation

public extension Vault.AuthProviders {
    struct TokenClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        private let basePath = "v1/auth/token"
        
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.config = config
            self.client = .init(config: vaultConfig)
        }
        
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        public func writeToken<T: Decodable & Sendable>(request: TokenRequest, orphan: Bool) async throws -> VaultResponse<T> {
            var suffix = orphan ? "create-orphan" : "create"
            
            if let roleName = request.roleName, !roleName.isEmpty {
                suffix += "/" + roleName.trim()
            }
            
            return try await client.makeCall(path: basePath + suffix, httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func getTokenRoleFor(role: String) async throws -> VaultResponse<TokenRoleResponse> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + "/roles/" + role.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func writeTokenRoleFor(role: String, request: TokenRoleRequest) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + "/roles/" + role.trim(), httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func deleteTokenRoleFor(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + "/roles/" + role.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getAllTokenRoles() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: basePath + "/roles", httpMethod: .list, wrapTimeToLive: nil)
        }
        
        public func lookup(clientToken: String) async throws -> VaultResponse<LookupResponse> {
            guard !clientToken.isEmpty else {
                throw VaultError(error: "Client token must not be empty")
            }
            
            let request = ["token": clientToken]
            
            return try await client.makeCall(path: basePath + "/lookup", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func lookupSelf() async throws -> VaultResponse<LookupResponse> {
            try await client.makeCall(path: basePath + "/lookup-self", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func renewSelf(increment: String? = nil) async throws -> VaultResponse<RenewSelfResponse> {
            var request: [String: String] = [:]
            
            if let increment {
                request["increment"] = increment
            }
            
            return try await client.makeCall(path: basePath + "/renew-self", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func revokeSelf() async throws {
            try await client.makeCall(path: basePath + "/revoke-self", httpMethod: .post, wrapTimeToLive: nil)
        }
        
        public struct Config {
            public init() {}
        }
    }
}

public extension Vault.AuthProviders {
    func buildTokenClient(config: TokenClient.Config) -> TokenClient {
        .init(config: config, client: client)
    }
}
