import Foundation

public extension Vault.SecretEngines {
    struct OpenLDAPClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
            
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
            
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
            
        public func write(dynamicRole: String, data: DynamicRole) async throws {
            guard !dynamicRole.isEmpty else {
                throw VaultError(error: "Dynamic Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/role/" + dynamicRole.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        public func get(dynamicRole: String) async throws -> VaultResponse<DynamicRole> {
            guard !dynamicRole.isEmpty else {
                throw VaultError(error: "Dynamic Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/role/" + dynamicRole.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func getAllDynamicRoles() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/role/", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func delete(dynamicRole: String) async throws {
            guard !dynamicRole.isEmpty else {
                throw VaultError(error: "Dynamic Role must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/role/" + dynamicRole.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getCredentialsFor(dynamicRole: String) async throws -> VaultResponse<DynamicRoleCredentials> {
            guard !dynamicRole.isEmpty else {
                throw VaultError(error: "Dynamic Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/creds/" + dynamicRole.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func write(staticRole: String, data: StaticRole) async throws {
            guard !staticRole.isEmpty else {
                throw VaultError(error: "Static Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/static-role/" + staticRole.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        public func get(staticRole: String) async throws -> VaultResponse<StaticRole> {
            guard !staticRole.isEmpty else {
                throw VaultError(error: "Static Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/static-role/" + staticRole.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func getAllStaticRoles() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/static-role/", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func delete(staticRole: String) async throws {
            guard !staticRole.isEmpty else {
                throw VaultError(error: "Static Role must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/static-role/" + staticRole.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getCredentialsFor(staticRole: String) async throws -> VaultResponse<StaticRoleCredentials> {
            guard !staticRole.isEmpty else {
                throw VaultError(error: "Static Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/static-cred/" + staticRole.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func rotateCredentialsFor(staticRole: String) async throws {
            guard !staticRole.isEmpty else {
                throw VaultError(error: "Static Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/rotate-role/" + staticRole.trim(), httpMethod: .post, wrapTimeToLive: nil)
        }
        
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
                
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.openLDAP.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    func buildOpenLDAPClient(config: OpenLDAPClient.Config) -> OpenLDAPClient {
        .init(config: config, client: client)
    }
}
