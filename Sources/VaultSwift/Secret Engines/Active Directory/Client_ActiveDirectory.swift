import Foundation

public extension Vault.ActiveDirectory {
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
            
        public func write(connectionConfig: ConnectionConfig) async throws(VaultError) {
            try await client.makeCall(path: self.config.mount + "/config", httpMethod: .post, request: connectionConfig, wrapTimeToLive: nil)
        }
        
        public func getConnectionConfig() async throws(VaultError) -> VaultResponse<ConnectionConfig> {
            try await client.makeCall(path: config.mount + "/config", httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func deleteConnectionConfig() async throws(VaultError) {
            try await client.makeCall(path: config.mount + "/config", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func write(role: String, data: RoleRequest) async throws(VaultError) {
            guard !role.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/roles/" + role.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        public func get(role: String) async throws(VaultError) -> VaultResponse<RoleResponse> {
            guard !role.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/roles/" + role.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func getAllRoles() async throws(VaultError) -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/roles", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func delete(role: String) async throws(VaultError) {
            guard !role.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/roles/" + role.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getCredentialsFor(role: String) async throws(VaultError) -> VaultResponse<Credentials> {
            guard !role.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/creds/" + role.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func rotateRootCredentials() async throws(VaultError) -> VaultResponse<[String: JSONAny]> {
            try await client.makeCall(path: config.mount + "/rotate-root", httpMethod: .post, wrapTimeToLive: nil)
        }
        
        public func getRootCredentials() async throws(VaultError) -> VaultResponse<[String: JSONAny]> {
            try await client.makeCall(path: config.mount + "/rotate-root", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func rotateCredentialsFor(role: String) async throws(VaultError) -> VaultResponse<[String: JSONAny]> {
            guard !role.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/rotate-role/" + role.trim(), httpMethod: .post, wrapTimeToLive: nil)
        }
            
        public struct Config {
            let mount: String
            let wrapTimeToLive: String?
                
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount ?? SecretEngineType.activeDirectory.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault {
    enum ActiveDirectory {}
    
    func buildActiveDirectoryClient(config: ActiveDirectory.Client.Config) -> ActiveDirectory.Client {
        .init(config: config, client: client)
    }
}
