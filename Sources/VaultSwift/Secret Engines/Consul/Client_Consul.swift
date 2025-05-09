import Foundation

public extension Vault.SecretEngines {
    struct ConsulClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
            
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
            
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        public func write(access: AccessConfig) async throws {
            try await client.makeCall(path: self.config.mount + "/config/access", httpMethod: .post, request: access, wrapTimeToLive: nil)
        }
        
        public func write(role: String, data: Role) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: self.config.mount + "/roles/" + role.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        public func get(role: String) async throws -> VaultResponse<Role> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: self.config.mount + "/roles/" + role.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func getAllRoles() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: self.config.mount + "/roles", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func delete(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: self.config.mount + "/roles/" + role.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getCredentialsFor(role: String) async throws -> VaultResponse<Credentials> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: self.config.mount + "/creds/" + role.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
            
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
                
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.consul.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    func buildConsulClient(config: ConsulClient.Config) -> ConsulClient {
        .init(config: config, client: client)
    }
}
