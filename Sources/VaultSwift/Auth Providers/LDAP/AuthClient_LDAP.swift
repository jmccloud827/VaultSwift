import Foundation

public extension Vault.AuthProviders {
    /// A client for interacting with the Vault LDAP (Lightweight Directory Access Protocol) authentication method.
    struct LDAPClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        private let basePath = "v1/auth"
        
        /// Initializes a new `LDAPClient` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the LDAP client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.config = config
            self.client = .init(config: vaultConfig)
        }
        
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// Writes a policy for an LDAP group.
        ///
        /// - Parameters:
        ///   - group: The name of the LDAP group.
        ///   - policies: The list of policies to assign to the group.
        /// - Throws: An error if the request fails or the group name is empty.
        public func write(group: String, policies: [String]) async throws {
            guard !group.isEmpty else {
                throw VaultError(error: "Group must not be empty")
            }
            
            let request = ["policies": policies.joined(separator: ",")]
            
            try await client.makeCall(path: basePath + config.mount + "/groups/" + group.trim(), httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Retrieves the policies for an LDAP group.
        ///
        /// - Parameter group: The name of the LDAP group.
        /// - Returns: A `VaultResponse` containing the policies.
        /// - Throws: An error if the request fails or the group name is empty.
        public func get(group: String) async throws -> VaultResponse<[String]> {
            guard !group.isEmpty else {
                throw VaultError(error: "Group must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/groups/" + group.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Retrieves all LDAP groups.
        ///
        /// - Returns: A `VaultResponse` containing the keys of all LDAP groups.
        /// - Throws: An error if the request fails.
        public func getAllGroups() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: basePath + config.mount + "/groups", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Deletes an LDAP group.
        ///
        /// - Parameter group: The name of the LDAP group.
        /// - Throws: An error if the request fails or the group name is empty.
        public func delete(group: String) async throws {
            guard !group.isEmpty else {
                throw VaultError(error: "Group must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/groups/" + group.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Writes a user to the LDAP authentication method.
        ///
        /// - Parameters:
        ///   - user: The name of the user.
        ///   - groups: The list of groups to assign to the user.
        ///   - policies: The list of policies to assign to the user.
        /// - Throws: An error if the request fails or the user name is empty.
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
        
        /// Retrieves the policies and groups for an LDAP user.
        ///
        /// - Parameter user: The name of the user.
        /// - Returns: A `VaultResponse` containing the user information.
        /// - Throws: An error if the request fails or the user name is empty.
        public func get<T: Decodable & Sendable>(user: String) async throws -> VaultResponse<T> {
            guard !user.isEmpty else {
                throw VaultError(error: "User must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/users/" + user.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Retrieves all LDAP users.
        ///
        /// - Returns: A `VaultResponse` containing the keys of all LDAP users.
        /// - Throws: An error if the request fails.
        public func getAllUsers() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: basePath + config.mount + "/users", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Deletes an LDAP user.
        ///
        /// - Parameter user: The name of the user.
        /// - Throws: An error if the request fails or the user name is empty.
        public func delete(user: String) async throws {
            guard !user.isEmpty else {
                throw VaultError(error: "User must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/users/" + user.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Configuration for the LDAP client.
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
                
            /// Initializes a new `Config` instance for the LDAP client.
            ///
            /// - Parameters:
            ///   - mount: The mount path for the LDAP engine (default is `ldap`).
            ///   - wrapTimeToLive: The wrap time to live for the requests (optional).
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MethodType.ldap.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.AuthProviders {
    /// Builds an `LDAPClient` with the specified configuration.
    ///
    /// - Parameter config: The `LDAPClient.Config` instance.
    /// - Returns: A new `LDAPClient` instance.
    func buildLDAPClient(config: LDAPClient.Config) -> LDAPClient {
        .init(config: config, client: client)
    }
}
