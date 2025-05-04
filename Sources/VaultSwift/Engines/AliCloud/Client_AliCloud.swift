import Foundation

public extension Vault.AliCloud {
    struct Client {
        private let config: Config
        private let client: Vault.Client
            
        public init(config: Config, vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
            
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        public func write(rootCredentials: RootCredentialsConfig) async throws(VaultError) {
            try await client.makeCall(path: self.config.mount + "/config", httpMethod: .post, request: rootCredentials, wrapTimeToLive: nil)
        }
        
        public func getRootCredentials() async throws(VaultError) -> VaultResponse<RootCredentialsConfig> {
            try await client.makeCall(path: self.config.mount + "/config", httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func write(role: String, data: RoleRequest) async throws(VaultError) {
            guard !role.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            try await client.makeCall(path: self.config.mount + "/role/" + role.trim(), httpMethod: .get, request: data, wrapTimeToLive: nil)
        }
        
        public func get(role: String) async throws(VaultError) -> VaultResponse<RoleResponse> {
            guard !role.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            return try await client.makeCall(path: self.config.mount + "/role/" + role.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func getAllRoles() async throws(VaultError) -> VaultResponse<[String: Vault.Keys]> {
            try await client.makeCall(path: self.config.mount + "/role", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func delete(role: String) async throws(VaultError) {
            guard !role.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            return try await client.makeCall(path: self.config.mount + "/role/" + role.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getCredentialsFor(role: String) async throws(VaultError) -> VaultResponse<Credentials> {
            guard !role.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/creds/" + role.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
            
        public struct Config {
            let mount: String
            let wrapTimeToLive: String?
                
            public init(mount: String?, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount ?? "alicloud")
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault {
    enum AliCloud {}
    
    func buildAliCloudClient(config: AliCloud.Client.Config) -> AliCloud.Client {
        .init(config: config, client: client)
    }
}
