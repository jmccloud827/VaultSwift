import Foundation

public extension Vault.OpenLDAP {
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
            
        public func write(dynamicRole: String, data: DynamicRole) async throws(VaultError) {
            guard !dynamicRole.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/role/" + dynamicRole.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        public func get(dynamicRole: String) async throws(VaultError) -> VaultResponse<DynamicRole> {
            guard !dynamicRole.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/role/" + dynamicRole.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func getAllDynamicRoles() async throws(VaultError) -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/role/", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func delete(dynamicRole: String) async throws(VaultError) {
            guard !dynamicRole.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/role/" + dynamicRole.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getCredentialsFor(dynamicRole: String) async throws(VaultError) -> VaultResponse<DynamicRoleCredentials> {
            guard !dynamicRole.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/creds/" + dynamicRole.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func write(staticRole: String, data: StaticRole) async throws(VaultError) {
            guard !staticRole.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/static-role/" + staticRole.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        public func get(staticRole: String) async throws(VaultError) -> VaultResponse<StaticRole> {
            guard !staticRole.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/static-role/" + staticRole.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func getAllStaticRoles() async throws(VaultError) -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/static-role/", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func delete(staticRole: String) async throws(VaultError) {
            guard !staticRole.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/static-role/" + staticRole.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getCredentialsFor(staticRole: String) async throws(VaultError) -> VaultResponse<StaticRoleCredentials> {
            guard !staticRole.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/static-cred/" + staticRole.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func rotateCredentialsFor(staticRole: String) async throws(VaultError) {
            guard !staticRole.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/rotate-role/" + staticRole.trim(), httpMethod: .post, wrapTimeToLive: nil)
        }
        
        public struct Config {
            let mount: String
            let wrapTimeToLive: String?
                
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount ?? SecretEngineType.openLDAP.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault {
    enum OpenLDAP {}
    
    func buildOpenLDAPClient(config: OpenLDAP.Client.Config) -> OpenLDAP.Client {
        .init(config: config, client: client)
    }
}
