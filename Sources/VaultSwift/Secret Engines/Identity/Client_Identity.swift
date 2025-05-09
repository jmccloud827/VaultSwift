import Foundation

public extension Vault.SecretEngines {
    /// A client for interacting with the Vault Identity secret engine.
    struct IdentityClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        
        /// Initializes a new `IdentityClient` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the Identity client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
        
        /// Initializes a new `IdentityClient` instance with the specified configuration and Vault client.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the Identity client.
        ///   - client: The `Vault.Client` instance.
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// Use this endpoint to generate a signed ID (OIDC) token.
        ///
        /// - Parameter role: The role to retrieve the token for.
        /// - Returns: A `VaultResponse` containing the token.
        /// - Throws: An error if the request fails or the role is empty.
        public func getTokenFor(role: String) async throws -> VaultResponse<Token> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/oidc/token/" + role.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint can verify the authenticity and active state of a signed ID token.
        ///
        /// - Parameters:
        ///   - token: The OIDC token to introspect.
        ///   - clientID: The client ID (optional).
        /// - Returns: A `VaultResponse` containing a boolean indicating if the token is valid.
        /// - Throws: An error if the request fails or the token is empty.
        public func introspect(token: String, clientID: String? = nil) async throws -> VaultResponse<Bool> {
            guard !token.isEmpty else {
                throw VaultError(error: "Token must not be empty")
            }
            
            let request = [
                "token": token,
                "client_id": clientID
            ]
            
            return try await client.makeCall(path: config.mount + "/oidc/introspect", httpMethod: .post, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint creates or updates an Entity.
        ///
        /// - Parameter entity: The `CreateEntityRequest` containing the entity data.
        /// - Returns: A `VaultResponse` containing the created entity response.
        /// - Throws: An error if the request fails.
        public func write(entity: CreateEntityRequest) async throws -> VaultResponse<CreateEntityResponse> {
            try await client.makeCall(path: config.mount + "/entity", httpMethod: .post, request: entity, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Retrieves an entity by its ID.
        ///
        /// - Parameter id: The ID of the entity to retrieve.
        /// - Returns: A `VaultResponse` containing the entity.
        /// - Throws: An error if the request fails or the ID is empty.
        public func getEntityFrom(id: String) async throws -> VaultResponse<Entity> {
            guard !id.isEmpty else {
                throw VaultError(error: "ID must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/entity/id/" + id.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Deletes an entity by its ID.
        ///
        /// - Parameter id: The ID of the entity to delete.
        /// - Throws: An error if the request fails or the ID is empty.
        public func deleteEntityFor(id: String) async throws {
            guard !id.isEmpty else {
                throw VaultError(error: "ID must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/entity/id/" + id.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Deletes multiple entities by their IDs.
        ///
        /// - Parameter ids: The IDs of the entities to delete.
        /// - Throws: An error if the request fails.
        public func deleteEntitiesFor(ids: [String]) async throws {
            let request = ["entity_ids": ids]
            
            try await client.makeCall(path: config.mount + "/entity/batch-delete", httpMethod: .post, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Gets all entities.
        ///
        /// - Returns: A `VaultResponse` containing the keys of all entities.
        /// - Throws: An error if the request fails.
        public func getAllEntities() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/entity/id", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Creates or updates an entity by its name.
        ///
        /// - Parameters:
        ///   - name: The name of the entity.
        ///   - entity: The `CreateEntityRequest` containing the entity data.
        /// - Returns: A `VaultResponse` containing the created or updated entity response.
        /// - Throws: An error if the request fails or the name is empty.
        public func writeEntityBy(name: String, entity: CreateEntityRequest) async throws -> VaultResponse<CreateEntityResponse> {
            guard !name.isEmpty else {
                throw VaultError(error: "Name must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/entity/name/" + name.trim(), httpMethod: .post, request: entity, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Retrieves an entity by its name.
        ///
        /// - Parameter name: The name of the entity to retrieve.
        /// - Returns: A `VaultResponse` containing the entity.
        /// - Throws: An error if the request fails or the name is empty.
        public func getEntityBy(name: String) async throws -> VaultResponse<Entity> {
            guard !name.isEmpty else {
                throw VaultError(error: "Name must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/entity/name/" + name.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Deletes an entity by its name.
        ///
        /// - Parameter name: The name of the entity to delete.
        /// - Returns: A `VaultResponse` containing the deleted entity response.
        /// - Throws: An error if the request fails or the name is empty.
        public func deleteEntityBy(name: String) async throws -> VaultResponse<CreateEntityResponse> {
            guard !name.isEmpty else {
                throw VaultError(error: "Name must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/entity/name/" + name.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Gets all entities by their names.
        ///
        /// - Returns: A `VaultResponse` containing the keys of all entities by their names.
        /// - Throws: An error if the request fails.
        public func getAllEntitiesByName() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/entity/name", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint merges many entities into one entity. Additionally,
        /// all groups associated with fromEntityIDs are merged with those of.
        ///
        /// - Parameter entities: The `MergeEntitiesRequest` containing the entities to merge.
        /// - Returns: A `VaultResponse` containing the keys of the merged entities.
        /// - Throws: An error if the request fails.
        public func merge(entities: MergeEntitiesRequest) async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/entity/merge", httpMethod: .post, request: entities, wrapTimeToLive: nil)
        }
        
        /// This endpoint creates or updates a key which is used by a role to sign tokens.
        ///
        /// - Parameters:
        ///   - key: The name of the key.
        ///   - data: The `KeyRequest` containing the key data.
        /// - Throws: An error if the request fails or the key name is empty.
        public func write(key: String, data: KeyRequest) async throws {
            guard !key.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/oidc/key/" + key.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        /// This endpoint reads a key which is used by a role to sign tokens.
        ///
        /// - Parameter key: The name of the key to retrieve.
        /// - Returns: A `VaultResponse` containing the key response.
        /// - Throws: An error if the request fails or the key name is empty.
        public func get(key: String) async throws -> VaultResponse<KeyResponse> {
            guard !key.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/oidc/key/" + key.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// This endpoint deletes a key.
        ///
        /// - Parameter key: The name of the key to delete.
        /// - Throws: An error if the request fails or the key name is empty.
        public func delete(key: String) async throws {
            guard !key.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/oidc/key/" + key.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Create or update a role. ID tokens are generated against a role and
        /// signed against a key.
        ///
        /// - Parameters:
        ///   - role: The name of the role.
        ///   - data: The `RoleRequest` containing the role data.
        /// - Throws: An error if the request fails or the role name is empty.
        public func write(role: String, data: RoleRequest) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/oidc/role/" + role.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        /// This endpoint queries a role and returns its configuration.
        ///
        /// - Parameter role: The name of the role to retrieve.
        /// - Returns: A `VaultResponse` containing the role response.
        /// - Throws: An error if the request fails or the role name is empty.
        public func get(role: String) async throws -> VaultResponse<RoleResponse> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/oidc/role/" + role.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// This endpoint deletes a role.
        ///
        /// - Parameter role: The name of the role to delete.
        /// - Throws: An error if the request fails or the role name is empty.
        public func delete(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/oidc/role/" + role.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Configuration for the Identity client.
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
            
            /// Initializes a new `Config` instance for the Identity client.
            ///
            /// - Parameters:
            ///   - mount: The mount path for the Identity engine (default is `identity`).
            ///   - wrapTimeToLive: The wrap time to live for the requests (optional).
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.identity.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    /// Builds an `IdentityClient` with the specified configuration.
    ///
    /// - Parameter config: The `IdentityClient.Config` instance.
    /// - Returns: A new `IdentityClient` instance.
    func buildIdentityClient(config: IdentityClient.Config) -> IdentityClient {
        .init(config: config, client: client)
    }
}
