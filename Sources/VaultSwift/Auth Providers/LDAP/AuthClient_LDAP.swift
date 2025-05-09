import Foundation

public extension Vault.AuthProviders {
    struct LDAPClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        private let basePath = "v1/auth"
        
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.config = config
            self.client = .init(config: vaultConfig)
        }
        
        init (config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        public func write(group: String, policies: [String]) async throws {
            guard !group.isEmpty else {
                throw VaultError(error: "Group must not be empty")
            }
            
            let request = ["policies": policies.joined(separator: ",")]
            
            try await client.makeCall(path: basePath + config.mount + "/groups/" + group.trim(), httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func get(group: String) async throws -> VaultResponse<[String]> {
            guard !group.isEmpty else {
                throw VaultError(error: "Group must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/groups/" + group.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func getAllGroups() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: basePath + config.mount + "/groups", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func delete(group: String) async throws {
            guard !group.isEmpty else {
                throw VaultError(error: "Group must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/groups/" + group.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func write(user: String, groups: [String], policies: [String]) async throws {
            guard !user.isEmpty else {
                throw VaultError(error: "User must not be empty")
            }
            
            let request = [
                "groups": groups.joined(separator: ","),
                "policies": policies.joined(separator: ",")
            ]
            
            try await client.makeCall(path: basePath + config.mount + "/users/" + user.trim(), httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func get<T: Decodable & Sendable>(user: String) async throws -> VaultResponse<T> {
            guard !user.isEmpty else {
                throw VaultError(error: "User must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/users/" + user.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func getAllUsers() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: basePath + config.mount + "/users", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func delete(user: String) async throws {
            guard !user.isEmpty else {
                throw VaultError(error: "User must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/users/" + user.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
                
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MethodType.ldap.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.AuthProviders {
    func buildLDAPClient(config: LDAPClient.Config) -> LDAPClient {
        .init(config: config, client: client)
    }
}
