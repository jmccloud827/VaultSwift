import Foundation

public extension Vault.SecretEngines {
    struct ActiveDirectoryClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
            
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
            
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
            
        public func write(connectionConfig: ConnectionConfig) async throws {
            try await client.makeCall(path: self.config.mount + "/config", httpMethod: .post, request: connectionConfig, wrapTimeToLive: nil)
        }
        
        public func getConnectionConfig() async throws -> VaultResponse<ConnectionConfig> {
            try await client.makeCall(path: config.mount + "/config", httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func deleteConnectionConfig() async throws {
            try await client.makeCall(path: config.mount + "/config", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func write(role: String, data: RoleRequest) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/roles/" + role.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        public func get(role: String) async throws -> VaultResponse<RoleResponse> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/roles/" + role.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func getAllRoles() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/roles", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func delete(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/roles/" + role.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getCredentialsFor(role: String) async throws -> VaultResponse<Credentials> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/creds/" + role.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func rotateRootCredentials<T: Decodable & Sendable>() async throws -> VaultResponse<T> {
            try await client.makeCall(path: config.mount + "/rotate-root", httpMethod: .post, wrapTimeToLive: nil)
        }
        
        public func getRootCredentials<T: Decodable & Sendable>() async throws -> VaultResponse<T> {
            try await client.makeCall(path: config.mount + "/rotate-root", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func rotateCredentialsFor<T: Decodable & Sendable>(role: String) async throws -> VaultResponse<T> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/rotate-role/" + role.trim(), httpMethod: .post, wrapTimeToLive: nil)
        }
            
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
                
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.activeDirectory.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    func buildActiveDirectoryClient(config: ActiveDirectoryClient.Config) -> ActiveDirectoryClient {
        .init(config: config, client: client)
    }
}
