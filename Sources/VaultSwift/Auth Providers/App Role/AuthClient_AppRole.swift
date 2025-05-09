import Foundation

public extension Vault.AuthProviders {
    /// A client for interacting with the Vault AppRole authentication method.
    struct AppRoleClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        private let basePath = "v1/auth"
        
        /// Initializes a new `AppRoleClient` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the AppRole client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.config = config
            self.client = .init(config: vaultConfig)
        }
        
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// This endpoint returns a list of available roles.
        /// Only the role names are returned, not any values.
        ///
        /// - Returns: A `VaultResponse` containing the keys of all roles.
        /// - Throws: An error if the request fails.
        public func getAllRoles() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: basePath + config.mount + "/role", httpMethod: .list, wrapTimeToLive: nil)
        }
        
        /// Creates a new AppRole or updates an existing AppRole.
        /// This endpoint supports both create and update capabilities.
        /// There can be one or more constraints enabled on the role.
        /// It is required to have at least one of them enabled while creating or updating a role.
        ///
        /// - Parameters:
        ///   - role: The name of the role.
        ///   - data: The data for the role.
        /// - Throws: An error if the request fails or the role name is empty.
        public func write(role: String, data: Role) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        /// Retrieves the data for a role.
        ///
        /// - Parameter role: The name of the role.
        /// - Returns: A `VaultResponse` containing the role data.
        /// - Throws: An error if the request fails or the role name is empty.
        public func get(role: String) async throws -> VaultResponse<Role> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Deletes a role.
        ///
        /// - Parameter role: The name of the role.
        /// - Throws: An error if the request fails or the role name is empty.
        public func delete(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Retrieves the role ID for a role.
        ///
        /// - Parameter role: The name of the role.
        /// - Returns: A `VaultResponse` containing the role ID.
        /// - Throws: An error if the request fails or the role name is empty.
        public func getIDFor(role: String) async throws -> VaultResponse<RoleID> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/role-id", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Writes a role ID for a role.
        ///
        /// - Parameters:
        ///   - role: The name of the role.
        ///   - data: The role ID data.
        /// - Throws: An error if the request fails or the role name is empty.
        public func writeIDFor(role: String, data: RoleID) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/role-id", httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        /// Retrieves the period for a role.
        ///
        /// - Parameter role: The name of the role.
        /// - Returns: A `VaultResponse` containing the role period.
        /// - Throws: An error if the request fails or the role name is empty.
        public func getPeriodFor(role: String) async throws -> VaultResponse<RolePeriod> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/period", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Writes a period for a role.
        ///
        /// - Parameters:
        ///   - role: The name of the role.
        ///   - period: The period value.
        /// - Throws: An error if the request fails or the role name is empty.
        public func writePeriodFor(role: String, period: Int) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            let request = ["token_period": period]
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/period", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Deletes the period for a role.
        ///
        /// - Parameter role: The name of the role.
        /// - Throws: An error if the request fails or the role name is empty.
        public func deletePeriodFor(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/period", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Generates and issues a new SecretID on an existing AppRole.
        /// Similar to tokens, the response will also contain a
        /// secretIDccessor value which can be used to read the properties
        /// of the SecretID without divulging the SecretID itself, and also to
        /// delete the SecretID from the AppRole.
        ///
        /// - Parameters:
        ///   - role: The name of the role.
        ///   - data: The secret ID request data.
        /// - Returns: A `VaultResponse` containing the secret ID response.
        /// - Throws: An error if the request fails or the role name is empty.
        public func writeSecretIDFor(role: String, data: SecretIDRequest) async throws -> VaultResponse<SecretIDResponse> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/secret-id", httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        /// Lists the accessors of all the SecretIDs issued against the AppRole.
        /// This includes the accessors for "custom" SecretIDs as well.
        ///
        /// - Parameter role: The name of the role.
        /// - Returns: A `VaultResponse` containing the keys of all secret ID accessors.
        /// - Throws: An error if the request fails or the role name is empty.
        public func getAllSecretIDAccessorsFor(role: String) async throws -> VaultResponse<Vault.Keys> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/secret-id", httpMethod: .list, wrapTimeToLive: nil)
        }
        
        /// Retrieves the secret ID info for a role.
        ///
        /// - Parameters:
        ///   - role: The name of the role.
        ///   - secretID: The secret ID.
        /// - Returns: A `VaultResponse` containing the secret ID info.
        /// - Throws: An error if the request fails or the role name or secret ID is empty.
        public func getSecretIDInfoFor(role: String, secretID: String) async throws -> VaultResponse<SecretIDInfo> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            guard !secretID.isEmpty else {
                throw VaultError(error: "Secret ID must not be empty")
            }
            
            let request = ["secret_id": secretID]
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/secret-id/lookup", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Deletes a secret ID for a role.
        ///
        /// - Parameters:
        ///   - role: The name of the role.
        ///   - secretID: The secret ID.
        /// - Throws: An error if the request fails or the role name or secret ID is empty.
        public func deleteSecretIDFor(role: String, secretID: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            guard !secretID.isEmpty else {
                throw VaultError(error: "Secret ID must not be empty")
            }
            
            let request = ["secret_id": secretID]
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/secret-id/destroy", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Retrieves the secret ID info for a role using an accessor.
        ///
        /// - Parameters:
        ///   - role: The name of the role.
        ///   - accessor: The secret ID accessor.
        /// - Returns: A `VaultResponse` containing the secret ID info.
        /// - Throws: An error if the request fails or the role name or accessor is empty.
        public func getSecretIDInfoFor(role: String, accessor: String) async throws -> VaultResponse<SecretIDInfo> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            guard !accessor.isEmpty else {
                throw VaultError(error: "Accessor must not be empty")
            }
            
            let request = ["secret_id_accessor": accessor]
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/secret-id-accessor/lookup", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Deletes a secret ID for a role using an accessor.
        ///
        /// - Parameters:
        ///   - role: The name of the role.
        ///   - accessor: The secret ID accessor.
        /// - Throws: An error if the request fails or the role name or accessor is empty.
        public func deleteSecretIDFor(role: String, accessor: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            guard !accessor.isEmpty else {
                throw VaultError(error: "Accessor must not be empty")
            }
            
            let request = ["secret_id_accessor": accessor]
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/secret-id-accessor/destroy", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Assigns a "custom" SecretID against an existing AppRole.
        /// This is used in the "Push" model of operation.
        ///
        /// - Parameters:
        ///   - role: The name of the role.
        ///   - data: The custom secret ID request data.
        /// - Returns: A `VaultResponse` containing the secret ID response.
        /// - Throws: An error if the request fails or the role name is empty.
        public func writeCustomSecretIDFor(role: String, data: CustomSecretIDRequest) async throws -> VaultResponse<SecretIDResponse> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/custom-secret-id", httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        /// Retrieves the secret ID usage for a role.
        ///
        /// - Parameter role: The name of the role.
        /// - Returns: A `VaultResponse` containing the secret ID usage.
        /// - Throws: An error if the request fails or the role name is empty.
        public func getSecretIDUsageFor(role: String) async throws -> VaultResponse<SecretIDUsage> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/secret-id-num-uses", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Writes the secret ID usage for a role.
        ///
        /// - Parameters:
        ///   - role: The name of the role.
        ///   - numberOfUses: The number of uses.
        /// - Throws: An error if the request fails or the role name is empty.
        public func writeSecretIDUsageFor(role: String, numberOfUses: Int) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            let request = ["secret_id_num_uses": numberOfUses]
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/secret-id-num-uses", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Deletes the secret ID usage for a role.
        ///
        /// - Parameter role: The name of the role.
        /// - Throws: An error if the request fails or the role name is empty.
        public func deleteSecretIDUsageFor(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/secret-id-num-uses", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Retrieves the secret ID time to live for a role.
        ///
        /// - Parameter role: The name of the role.
        /// - Returns: A `VaultResponse` containing the secret ID time to live.
        /// - Throws: An error if the request fails or the role name is empty.
        public func getSecretIDTimeToLiveFor(role: String) async throws -> VaultResponse<SecretIDTimeToLive> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/secret-id-ttl", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Writes the secret ID time to live for a role.
        ///
        /// - Parameters:
        ///   - role: The name of the role.
        ///   - timeToLive: The time to live value.
        /// - Throws: An error if the request fails or the role name is empty.
        public func writeSecretIDTimeToLiveFor(role: String, timeToLive: Int) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            let request = ["secret_id_ttl": timeToLive]
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/secret-id-ttl", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Deletes the secret ID time to live for a role.
        ///
        /// - Parameter role: The name of the role.
        /// - Throws: An error if the request fails or the role name is empty.
        public func deleteSecretIDTimeToLiveFor(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/secret-id-ttl", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Retrieves the secret ID binding for a role.
        ///
        /// - Parameter role: The name of the role.
        /// - Returns: A `VaultResponse` containing the secret ID binding.
        /// - Throws: An error if the request fails or the role name is empty.
        public func getSecretIDBindingFor(role: String) async throws -> VaultResponse<SecretIDBinding> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/bind-secret-id", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Writes the secret ID binding for a role.
        ///
        /// - Parameters:
        ///   - role: The name of the role.
        ///   - bind: The bind value.
        /// - Throws: An error if the request fails or the role name is empty.
        public func writeSecretIDBindingFor(role: String, bind: Bool) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            let request = ["bind_secret_id": bind]
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/bind-secret-id", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Deletes the secret ID binding for a role.
        ///
        /// - Parameter role: The name of the role.
        /// - Throws: An error if the request fails or the role name is empty.
        public func deleteSecretIDBindingFor(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/bind-secret-id", httpMethod: .delete, wrapTimeToLive: nil)
        }

        /// Retrieves the secret ID binding CIDRs for a role.
        ///
        /// - Parameter role: The name of the role.
        /// - Returns: A `VaultResponse` containing the secret ID binding CIDRs.
        /// - Throws: An error if the request fails or the role name is empty.
        public func getSecretIDBindingCIDRsFor(role: String) async throws -> VaultResponse<SecretIDBindingCIDRs> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/secret-id-bound-cidrs", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Writes the secret ID binding CIDRs for a role.
        ///
        /// - Parameters:
        ///   - role: The name of the role.
        ///   - boundCIDRs: The list of CIDRs to bind the secret ID.
        /// - Throws: An error if the request fails or the role name is empty.
        public func writeSecretIDBindingCIDRsFor(role: String, boundCIDRs: [String]) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            let request = ["secret_id_bound_cidrs": boundCIDRs]
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/secret-id-bound-cidrs", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Deletes the secret ID binding CIDRs for a role.
        ///
        /// - Parameter role: The name of the role.
        /// - Throws: An error if the request fails or the role name is empty.
        public func deleteSecretIDBindingCIDRsFor(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/secret-id-bound-cidrs", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Retrieves the policies for a role.
        ///
        /// - Parameter role: The name of the role.
        /// - Returns: A `VaultResponse` containing the role policies.
        /// - Throws: An error if the request fails or the role name is empty.
        public func getPoliciesFor(role: String) async throws -> VaultResponse<RolePolicies> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/policies", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Writes policies for a role.
        ///
        /// - Parameters:
        ///   - role: The name of the role.
        ///   - policies: The policies to assign to the role.
        /// - Throws: An error if the request fails or the role name is empty.
        public func writePoliciesFor(role: String, policies: RolePolicies) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/policies", httpMethod: .post, request: policies, wrapTimeToLive: nil)
        }
        
        /// Deletes the policies for a role.
        ///
        /// - Parameter role: The name of the role.
        /// - Throws: An error if the request fails or the role name is empty.
        public func deletePoliciesFor(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/policies", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Retrieves the token time to live (TTL) for a role.
        ///
        /// - Parameter role: The name of the role.
        /// - Returns: A `VaultResponse` containing the token TTL.
        /// - Throws: An error if the request fails or the role name is empty.
        public func getTokenTimeToLiveFor(role: String) async throws -> VaultResponse<TokenTimeToLive> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/token-ttl", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Writes the token time to live (TTL) for a role.
        ///
        /// - Parameters:
        ///   - role: The name of the role.
        ///   - timeToLive: The time to live value.
        /// - Throws: An error if the request fails or the role name is empty.
        public func writeTokenTimeToLiveFor(role: String, timeToLive: Int) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            let request = ["token_ttl": timeToLive]
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/token-ttl", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Deletes the token time to live (TTL) for a role.
        ///
        /// - Parameter role: The name of the role.
        /// - Throws: An error if the request fails or the role name is empty.
        public func deleteTokenTimeToLiveFor(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/token-ttl", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Retrieves the maximum token time to live (TTL) for a role.
        ///
        /// - Parameter role: The name of the role.
        /// - Returns: A `VaultResponse` containing the maximum token TTL.
        /// - Throws: An error if the request fails or the role name is empty.
        public func getTokenMaxTimeToLiveFor(role: String) async throws -> VaultResponse<TokenMaxTimeToLive> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/token-max-ttl", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Writes the maximum token time to live (TTL) for a role.
        ///
        /// - Parameters:
        ///   - role: The name of the role.
        ///   - timeToLive: The time to live value.
        /// - Throws: An error if the request fails or the role name is empty.
        public func writeMaxTokenTimeToLiveFor(role: String, timeToLive: Int) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            let request = ["token_max_ttl": timeToLive]
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/token-max-ttl", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Deletes the maximum token time to live (TTL) for a role.
        ///
        /// - Parameter role: The name of the role.
        /// - Throws: An error if the request fails or the role name is empty.
        public func deleteMaxTokenTimeToLiveFor(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/token-max-ttl", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Retrieves the token bound CIDRs for a role.
        ///
        /// - Parameter role: The name of the role.
        /// - Returns: A `VaultResponse` containing the token bound CIDRs.
        /// - Throws: An error if the request fails or the role name is empty.
        public func getTokenBoundCIDRsFor(role: String) async throws -> VaultResponse<TokenBoundCIDRs> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/token-bound-cidrs", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Writes the token bound CIDRs for a role.
        ///
        /// - Parameters:
        ///   - role: The name of the role.
        ///   - tokenBoundCIDRS: The CIDRs to bind the token.
        /// - Throws: An error if the request fails or the role name is empty.
        public func writeTokenBoundCIDRsFor(role: String, tokenBoundCIDRS: Int) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            let request = ["token_bound_cidrs": tokenBoundCIDRS]
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/token-bound-cidrs", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Deletes the token bound CIDRs for a role.
        ///
        /// - Parameter role: The name of the role.
        /// - Throws: An error if the request fails or the role name is empty.
        public func deleteTokenBoundCIDRsFor(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/token-bound-cidrs", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Performs some maintenance tasks to clean up invalid entries that may remain in the token store.
        /// Generally, running this is not needed unless upgrade notes or support personnel suggest it.
        /// This may perform a lot of I/O to the storage method so should be used sparingly.
        ///
        /// - Returns: A `VaultResponse` containing the tidy response.
        /// - Throws: An error if the request fails.
        public func tidyTokens<T: Decodable & Sendable>() async throws -> VaultResponse<T> {
            try await client.makeCall(path: basePath + config.mount + "/tidy/secret-id", httpMethod: .post, wrapTimeToLive: nil)
        }
        
        /// Useful to generate the login token as an explicit api.
        /// Unauthenticated API.
        ///
        /// - Parameters:
        ///   - roleID: The role ID.
        ///   - secretID: The secret ID (optional).
        /// - Returns: A `VaultResponse` containing the login response.
        /// - Throws: An error if the request fails.
        public func login<T: Decodable & Sendable>(roleID: String, secretID: String?) async throws -> VaultResponse<T> {
            var request = ["role_id": roleID]
            
            if let secretID {
                request["secret_id"] = secretID
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/login", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Configuration for the AppRole client.
        public struct Config {
            public let mount: String
                
            /// Initializes a new `Config` instance for the AppRole client.
            ///
            /// - Parameter mount: The mount path for the AppRole engine (default is `approle`).
            public init(mount: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MethodType.appRole.rawValue)
            }
        }
    }
}

public extension Vault.AuthProviders {
    /// Builds a `AppRoleClient` with the specified configuration.
    ///
    /// - Parameter config: The `AppRoleClient.Config` instance.
    /// - Returns: A new `AppRoleClient` instance.
    func buildAppRoleClient(config: AppRoleClient.Config) -> AppRoleClient {
        .init(config: config, client: client)
    }
}
