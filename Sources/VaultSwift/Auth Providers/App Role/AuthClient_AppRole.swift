import Foundation

public extension Vault.AuthProviders {
    struct AppRoleClient: BackendClient {
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
        
        public func getAllRoles() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: basePath + config.mount + "/role", httpMethod: .list, wrapTimeToLive: nil)
        }
        
        public func write(role: String, data: Role) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        public func get(role: String) async throws -> VaultResponse<Role> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func delete(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getIDFor(role: String) async throws -> VaultResponse<RoleID> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/role-id", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func writeIDFor(role: String, data: RoleID) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/role-id", httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        public func getPeriodFor(role: String) async throws -> VaultResponse<RolePeriod> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/period", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func writePeriodFor(role: String, period: Int) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            let request = ["token_period": period]
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/period", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func deletePeriodFor(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/period", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func writeSecretIDFor(role: String, data: SecretIDRequest) async throws -> VaultResponse<SecretIDResponse> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/secret-id", httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        public func getAllSecretIDAccessorsFor(role: String) async throws -> VaultResponse<Vault.Keys> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/secret-id", httpMethod: .list, wrapTimeToLive: nil)
        }
        
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
        
        public func deleteSecretIDFor(role: String, secretID: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            guard !secretID.isEmpty else {
                throw VaultError(error: "Secret ID must not be empty")
            }
            
            let request = ["secret_id": secretID]
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/secret-id/destroy", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
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
        
        public func deleteSecretIDFor(role: String, accessor: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            guard !accessor.isEmpty else {
                throw VaultError(error: "Accessor must not be empty")
            }
            
            let request = ["secret_id_accessor": accessor]
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/secret-id-accessor/destroy", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func writeCustomSecretIDFor(role: String, data: CustomSecretIDRequest) async throws -> VaultResponse<SecretIDResponse> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/custom-secret-id", httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        public func getSecretIDUsageFor(role: String) async throws -> VaultResponse<SecretIDUsage> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/secret-id-num-uses", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func writeSecretIDUsageFor(role: String, numberOfUses: Int) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            let request = ["secret_id_num_uses": numberOfUses]
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/secret-id-num-uses", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func deleteSecretIDUsageFor(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/secret-id-num-uses", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getSecretIDTimeToLiveFor(role: String) async throws -> VaultResponse<SecretIDTimeToLive> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/secret-id-ttl", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func writeSecretIDTimeToLiveFor(role: String, timeToLive: Int) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            let request = ["secret_id_ttl": timeToLive]
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/secret-id-ttl", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func deleteSecretIDTimeToLiveFor(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/secret-id-ttl", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getSecretIDBindingFor(role: String) async throws -> VaultResponse<SecretIDBinding> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/bind-secret-id", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func writeSecretIDBindingFor(role: String, bind: Bool) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            let request = ["bind_secret_id": bind]
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/bind-secret-id", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func deleteSecretIDBindingFor(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/bind-secret-id", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getSecretIDBindingCIDRsFor(role: String) async throws -> VaultResponse<SecretIDBindingCIDRs> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/secret-id-bound-cidrs", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func writeSecretIDBindingCIDRsFor(role: String, boundCIDRs: [String]) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            let request = ["secret_id_bound_cidrs": boundCIDRs]
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/secret-id-bound-cidrs", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func deleteSecretIDBindingCIDRsFor(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/secret-id-bound-cidrs", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getPoliciesFor(role: String) async throws -> VaultResponse<RolePolicies> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/policies", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func writePoliciesFor(role: String, policies: RolePolicies) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/policies", httpMethod: .post, request: policies, wrapTimeToLive: nil)
        }
        
        public func deletePoliciesFor(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/policies", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getTokenTimeToLiveFor(role: String) async throws -> VaultResponse<TokenTimeToLive> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/token-ttl", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func writeTokenTimeToLiveFor(role: String, timeToLive: Int) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            let request = ["token_ttl": timeToLive]
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/token-ttl", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func deleteTokenTimeToLiveFor(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/token-ttl", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getTokenMaxTimeToLiveFor(role: String) async throws -> VaultResponse<TokenMaxTimeToLive> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/token-max-ttl", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func writeMaxTokenTimeToLiveFor(role: String, timeToLive: Int) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            let request = ["token_max_ttl": timeToLive]
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/token-max-ttl", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func deleteMaxTokenTimeToLiveFor(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/token-max-ttl", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getTokenBoundCIDRsFor(role: String) async throws -> VaultResponse<TokenBoundCIDRs> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/token-bound-cidrs", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func writeTokenBoundCIDRsFor(role: String, tokenBoundCIDRS: Int) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            let request = ["token_bound_cidrs": tokenBoundCIDRS]
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/token-bound-cidrs", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func deleteTokenBoundCIDRsFor(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: basePath + config.mount + "/role/" + role.trim() + "/token-bound-cidrs", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func tidyTokens<T: Decodable & Sendable>() async throws -> VaultResponse<T> {
            try await client.makeCall(path: basePath + config.mount + "/tidy/secret-id", httpMethod: .post, wrapTimeToLive: nil)
        }
        
        public func login<T: Decodable & Sendable>(roleID: String, secretID: String?) async throws -> VaultResponse<T> {
            var request = ["role_id": roleID]
            
            if let secretID {
                request["secret_id"] = secretID
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/login", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public struct Config {
            public let mount: String
                
            public init(mount: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MethodType.appRole.rawValue)
            }
        }
    }
}

public extension Vault.AuthProviders {
    func buildAppRoleClient(config: AppRoleClient.Config) -> AppRoleClient {
        .init(config: config, client: client)
    }
}
