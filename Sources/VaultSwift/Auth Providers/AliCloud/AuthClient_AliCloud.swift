import Foundation

public extension Vault.AuthProviders {
    struct AliCloudClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        private let basePath = "v1/auth"
        
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.config = config
            self.client = .init(config: vaultConfig)
        }
        
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        public func getAllRoles() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: basePath + config.mount + "/role", httpMethod: .list, wrapTimeToLive: nil)
        }
        
        public func write(role: String, data: RoleRequest) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        public func get(role: String) async throws -> VaultResponse<RoleResponse> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func delete(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public struct Config {
            public let mount: String
                
            public init(mount: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MethodType.aliCloud.rawValue)
            }
        }
    }
}

public extension Vault.AuthProviders {
    func buildAliCloudClient(config: AliCloudClient.Config) -> AliCloudClient {
        .init(config: config, client: client)
    }
}
