import Foundation

public extension Vault.Identity {
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
        
        public func getTokenFor(role: String) async throws(VaultError) -> VaultResponse<Token> {
            guard !role.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/oidc/token/" + role.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func introspect(token: String, clientID: String? = nil) async throws(VaultError) -> VaultResponse<Bool> {
            guard !token.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            let request = [
                "token": token,
                "client_id": clientID
            ]
            
            return try await client.makeCall(path: config.mount + "/oidc/introspect", httpMethod: .post, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func write(entity: CreateEntityRequest) async throws(VaultError) -> VaultResponse<CreateEntityResponse> {
            try await client.makeCall(path: config.mount + "/entity", httpMethod: .post, request: entity, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func getEntityFrom(id: String) async throws(VaultError) -> VaultResponse<EntityResponse> {
            guard !id.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/entity/id/" + id.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func deleteEntityFor(id: String) async throws(VaultError) {
            guard !id.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/entity/id/" + id.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func deleteEntitiesFor(ids: [String]) async throws(VaultError) {
            let request = ["entity_ids" : ids]
            
            try await client.makeCall(path: config.mount + "/entity/batch-delete", httpMethod: .post, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func listAllEntities() async throws(VaultError) -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/entity/id", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func writeEntityBy(name: String, entity: CreateEntityByNameRequest) async throws(VaultError) -> VaultResponse<CreateEntityResponse> {
            guard !name.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
           return try await client.makeCall(path: config.mount + "/entity/name/" + name.trim(), httpMethod: .post, request: entity, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func getEntityBy(name: String) async throws(VaultError) -> VaultResponse<CreateEntityResponse> {
            guard !name.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/entity/name/" + name.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func deleteEntityBy(name: String) async throws(VaultError) -> VaultResponse<CreateEntityResponse> {
            guard !name.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/entity/name/" + name.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func listAllEntitiesByName() async throws(VaultError) -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/entity/name", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func merge(entities: MergeEntitiesRequest) async throws(VaultError) -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/entity/merge", httpMethod: .post, request: entities, wrapTimeToLive: nil)
        }
        
        public func write(key: String, data: KeyRequest) async throws(VaultError) {
            guard !key.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/oidc/key/" + key.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        public func get(key: String) async throws(VaultError) -> VaultResponse<KeyResponse> {
            guard !key.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/oidc/key/" + key.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func delete(key: String) async throws(VaultError) {
            guard !key.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/oidc/key/" + key.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func write(role: String, data: RoleRequest) async throws(VaultError) {
            guard !role.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/oidc/role/" + role.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        public func get(role: String) async throws(VaultError) -> VaultResponse<KeyResponse> {
            guard !role.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/oidc/role/" + role.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func delete(role: String) async throws(VaultError) {
            guard !role.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/oidc/role/" + role.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
            
        public struct Config {
            let mount: String
            let wrapTimeToLive: String?
                
            public init(mount: String?, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount ?? "identity")
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault {
    enum Identity {}
    
    func buildIdentityClient(config: Identity.Client.Config) -> Identity.Client {
        .init(config: config, client: client)
    }
}
