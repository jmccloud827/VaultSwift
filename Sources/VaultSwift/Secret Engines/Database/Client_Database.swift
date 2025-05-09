import Foundation

public extension Vault.SecretEngines {
    struct DatabaseClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
            
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
            
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        public func write(connection: String, config: ConnectionConfigRequest) async throws {
            try await client.makeCall(path: self.config.mount + "/config/" + connection.trim(), httpMethod: .post, request: config, wrapTimeToLive: nil)
        }
        
        public func get(connection: String) async throws -> VaultResponse<ConnectionConfigResponse> {
            guard !connection.isEmpty else {
                throw VaultError(error: "Connection must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/config/" + connection.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func getAllConnections() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/config?list=true", httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func delete(connection: String) async throws {
            try await client.makeCall(path: config.mount + "/config/" + connection.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func reset(connection: String) async throws {
            try await client.makeCall(path: config.mount + "/reset/" + connection.trim(), httpMethod: .post, wrapTimeToLive: nil)
        }
        
        public func reload(plugin: String) async throws {
            try await client.makeCall(path: config.mount + "/reload/" + plugin.trim(), httpMethod: .post, wrapTimeToLive: nil)
        }
        
        public func rotateRootCredentialsFor(connection: String) async throws {
            try await client.makeCall(path: config.mount + "/rotate-root/" + connection.trim(), httpMethod: .post, wrapTimeToLive: nil)
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
        
        public func getCredentialsFor(role: String) async throws -> VaultResponse<Vault.UserCredentials> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/creds/" + role.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func write(staticRole: String, data: StaticRole) async throws {
            guard !staticRole.isEmpty else {
                throw VaultError(error: "Static Role must not be empty")
            }
            
            try await client.makeCall(path: self.config.mount + "/static-roles/" + staticRole.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        public func get(staticRole: String) async throws -> VaultResponse<StaticRole> {
            guard !staticRole.isEmpty else {
                throw VaultError(error: "Static Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/static-roles/" + staticRole.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func getAllStaticRoles() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/static-roles", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func delete(staticRole: String) async throws {
            guard !staticRole.isEmpty else {
                throw VaultError(error: "Static Role must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/static-roles/" + staticRole.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getStaticCredentialsFor(role: String) async throws -> VaultResponse<StaticCredentials> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/static-creds/" + role.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func rotateStaticCredentialsFor(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: self.config.mount + "/rotate-roles/" + role.trim(), httpMethod: .post, wrapTimeToLive: nil)
        }
            
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
                
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.database.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    func buildDatabaseClient(config: DatabaseClient.Config) -> DatabaseClient {
        .init(config: config, client: client)
    }
}
