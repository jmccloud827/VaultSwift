import Foundation

public extension Vault.SecretEngines {
    struct AliCloudClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
            
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
            
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        public func write(rootCredentials: RootCredentialsConfig) async throws {
            try await client.makeCall(path: self.config.mount + "/config", httpMethod: .post, request: rootCredentials, wrapTimeToLive: nil)
        }
        
        public func getRootCredentials() async throws -> VaultResponse<RootCredentialsConfig> {
            try await client.makeCall(path: self.config.mount + "/config", httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func write(role: String, data: RoleRequest) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: self.config.mount + "/role/" + role.trim(), httpMethod: .get, request: data, wrapTimeToLive: nil)
        }
        
        public func get(role: String) async throws -> VaultResponse<RoleResponse> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: self.config.mount + "/role/" + role.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func getAllRoles() async throws -> VaultResponse<[String: Vault.Keys]> {
            try await client.makeCall(path: self.config.mount + "/role", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func delete(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: self.config.mount + "/role/" + role.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getCredentialsFor(role: String) async throws -> VaultResponse<Credentials> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/creds/" + role.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
            
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
                
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.aliCloud.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    func buildAliCloudClient(config: AliCloudClient.Config) -> AliCloudClient {
        .init(config: config, client: client)
    }
}
