import Foundation

public extension Vault.SystemBackend {
    struct Client {
        public let plugins: Plugins
        public let enterprise: Enterprise
        private let client: Vault.Client
        private let basePath = "v1/sys"
            
        public init(vaultConfig: Vault.Config) {
            self.init(client: .init(config: vaultConfig))
        }
            
        init(client: Vault.Client) {
            self.plugins = .init(client: client)
            self.enterprise = .init(client: client)
            self.client = client
        }
        
        public func getAuditBackends() async throws(VaultError) -> VaultResponse<[String: AuditBackend]> {
            try await client.makeCall(path: basePath + "/audit", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func mount(auditBackend: AuditBackend, mount: String? = nil) async throws(VaultError) {
            try await client.makeCall(path: basePath + "/audit/" + (mount?.trim() ?? auditBackend.type.typeString), httpMethod: .post, request: auditBackend, wrapTimeToLive: nil)
        }
        
        public func unmount(auditBackend: AuditBackend.`Type`, mount: String? = nil) async throws(VaultError) {
            try await client.makeCall(path: basePath + "/audit/" + (mount?.trim() ?? auditBackend.typeString), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func auditHashFor(path: String, input: String) async throws(VaultError) -> VaultResponse<AuditHash> {
            let request = ["input": input]
            
            return try await client.makeCall(path: basePath + "/audit-hash/" + path.trim(), httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func getAuthBackends() async throws(VaultError) -> VaultResponse<[String: AuthBackend]> {
            try await client.makeCall(path: basePath + "/auth", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func mount(authBackend: AuthBackend, mount: String? = nil) async throws(VaultError) {
            try await client.makeCall(path: basePath + "/auth/" + (mount?.trim() ?? authBackend.type.rawValue), httpMethod: .post, request: authBackend, wrapTimeToLive: nil)
        }
        
        public func unmount(authBackend: Vault.AuthProviderType, mount: String? = nil) async throws(VaultError) {
            try await client.makeCall(path: basePath + "/auth/" + (mount?.trim() ?? authBackend.rawValue), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getConfigFor(authBackend: Vault.AuthProviderType, mount: String? = nil) async throws(VaultError) -> VaultResponse<BackendConfig> {
            try await client.makeCall(path: basePath + "/auth/" + (mount?.trim() ?? authBackend.rawValue) + "/tune", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func writeConfigFor(authBackend: Vault.AuthProviderType, mount: String? = nil, config: BackendConfig) async throws(VaultError) {
            try await client.makeCall(path: basePath + "/auth/" + (mount?.trim() ?? authBackend.rawValue) + "/tune", httpMethod: .post, request: config, wrapTimeToLive: nil)
        }
        
        public func getCapabilitiesFor(token: String, path: String) async throws(VaultError) -> VaultResponse<[String: JSONAny]> {
            let request = ["path": path, "token": token]
            
            return try await client.makeCall(path: basePath + "/capabilities", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func getCapabilitiesFor(tokenAccessor: String, path: String) async throws(VaultError) -> VaultResponse<[String: JSONAny]> {
            let request = ["path": path, "accessor": tokenAccessor]
            
            return try await client.makeCall(path: basePath + "/capabilities-accessor", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func getCallingTokenCapabilitiesFor(path: String) async throws(VaultError) -> VaultResponse<[String: JSONAny]> {
            let request = ["path": path]
            
            return try await client.makeCall(path: basePath + "/capabilities-self", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func getAllAuditRequestHeaders() async throws(VaultError) -> VaultResponse<RequestHeaderList> {
            try await client.makeCall(path: basePath + "/config/auditing/request-headers", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func get(auditRequestHeader: String) async throws(VaultError) -> VaultResponse<RequestHeaderList> {
            try await client.makeCall(path: basePath + "/config/auditing/request-headers/" + auditRequestHeader, httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func write(auditRequestHeader: String, hmac: Bool = false) async throws(VaultError) {
            let request = ["hmac": hmac]
            
            try await client.makeCall(path: basePath + "/config/auditing/request-headers/" + auditRequestHeader, httpMethod: .put, request: request, wrapTimeToLive: nil)
        }
        
        public func delete(auditRequestHeader: String) async throws(VaultError) {
            try await client.makeCall(path: basePath + "/config/auditing/request-headers/" + auditRequestHeader, httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getCORSConfig() async throws(VaultError) -> VaultResponse<CORSConfig> {
            try await client.makeCall(path: basePath + "/config/cors", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func write(corsConfig: CORSConfig) async throws(VaultError) {
            try await client.makeCall(path: basePath + "/config/cors", httpMethod: .put, request: corsConfig, wrapTimeToLive: nil)
        }
        
        public func deleteCORSConfig() async throws(VaultError) {
            try await client.makeCall(path: basePath + "/config/cors", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func startRootTokenGeneration(base64EncodedOneTimePassword: String, pgpKey: String) async throws(VaultError) -> RootTokenGenerationStatus {
            let request = [
                "otp": base64EncodedOneTimePassword,
                "pgp_key": pgpKey
            ]
            
            return try await client.makeCall(path: basePath + "/generate-root/attempt", httpMethod: .put, request: request, wrapTimeToLive: nil)
        }
        
        public func getRootTokenGenerationStatus() async throws(VaultError) -> RootTokenGenerationStatus {
            try await client.makeCall(path: basePath + "/generate-root/attempt", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func cancelRootTokenGeneration() async throws(VaultError) {
            try await client.makeCall(path: basePath + "/generate-root/attempt", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func continueRootTokenGeneration(masterShareKey: String, nonce: String) async throws(VaultError) -> RootTokenGenerationStatus {
            let request = [
                "key": masterShareKey,
                "nonce": nonce
            ]
            
            return try await client.makeCall(path: basePath + "v1/sys/generate-root/update", httpMethod: .put, request: request, wrapTimeToLive: nil)
        }
        
        public func getInitializeStatus() async throws(VaultError) -> Bool {
            let response: [String: Bool] = try await client.makeCall(path: basePath + "/init", httpMethod: .get, wrapTimeToLive: nil)
            
            guard let isInitialized = response.first?.value else {
                throw .init(error: "Corrupted response")
            }
            
            return isInitialized
        }
        
        public func initialize(options: InitOptions) async throws(VaultError) -> MasterCredentials {
            try await client.makeCall(path: basePath + "/init", httpMethod: .put, request: options, wrapTimeToLive: nil)
        }
        
        public func getKeyStatus() async throws(VaultError) -> VaultResponse<KeyStatus> {
            try await client.makeCall(path: basePath + "/key-status", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func getLeader() async throws(VaultError) -> Leader {
            try await client.makeCall(path: basePath + "/leader", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func get(lease: String) async throws(VaultError) -> VaultResponse<Lease> {
            let request = ["lease_id": lease]
            
            return try await client.makeCall(path: basePath + "/leases/lookup", httpMethod: .put, request: request, wrapTimeToLive: nil)
        }
        
        public func getAllLeases(prefix: String) async throws(VaultError) -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: basePath + "/leases/lookup" + prefix.trim() + "/", httpMethod: .list, wrapTimeToLive: nil)
        }
        
        public func renew(lease: String, incrementSeconds: Int) async throws(VaultError) -> VaultResponse<RenewLeaseResponse> {
            let request = RenewLeaseRequest(lease: lease, incrementSeconds: incrementSeconds)
            
            return try await client.makeCall(path: basePath + "/leases/renew", httpMethod: .put, request: request, wrapTimeToLive: nil)
        }
        
        public func revoke(lease: String) async throws(VaultError) {
            let request = ["lease_id": lease]
            
            try await client.makeCall(path: basePath + "/leases/revoke", httpMethod: .put, request: request, wrapTimeToLive: nil)
        }
        
        public func forceRevoke(lease: String) async throws(VaultError) {
            try await client.makeCall(path: basePath + "/leases/revoke-force/" + lease.trim() + "/", httpMethod: .put, wrapTimeToLive: nil)
        }
        
        public func revokeLease(prefix: String) async throws(VaultError) {
            try await client.makeCall(path: basePath + "/leases/revoke-prefix/" + prefix.trim() + "/", httpMethod: .put, wrapTimeToLive: nil)
        }
        
        public func getVerbosityOfAllLoggers() async throws(VaultError) -> VaultResponse<[String: JSONAny]> {
            try await client.makeCall(path: basePath + "/loggers", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func getVerbosityOf(logger: String) async throws(VaultError) -> VaultResponse<[String: JSONAny]> {
            try await client.makeCall(path: basePath + "/loggers/" + logger.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func writeVerbosityOfAllLoggers(level: LogVerbosityLevel) async throws(VaultError) {
            let request = ["level": level]
            
            try await client.makeCall(path: basePath + "/loggers", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func writeVerbosityOf(logger: String, level: LogVerbosityLevel) async throws(VaultError) {
            let request = ["level": level]
            
            try await client.makeCall(path: basePath + "/loggers/" + logger.trim(), httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func revertVerbosityOfAllLoggers() async throws(VaultError) -> VaultResponse<[String: JSONAny]> {
            try await client.makeCall(path: basePath + "/loggers", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func revertVerbosityOf(logger: String) async throws(VaultError) -> VaultResponse<[String: JSONAny]> {
            try await client.makeCall(path: basePath + "/loggers/" + logger.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getAllSecretEngines() async throws(VaultError) -> VaultResponse<[String: SecretEngine]> {
            try await client.makeCall(path: basePath + "/mounts", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func get(secretEngine: String) async throws(VaultError) -> VaultResponse<SecretEngine> {
            try await client.makeCall(path: basePath + "/mounts/" + secretEngine.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func mount(secretEngine: SecretEngine, mount: String? = nil) async throws(VaultError) {
            try await client.makeCall(path: basePath + "/mounts/" + (mount?.trim() ?? secretEngine.type.rawValue), httpMethod: .post, request: secretEngine, wrapTimeToLive: nil)
        }
        
        public func unmount(secretEngine: Vault.SecretEngineType, mount: String? = nil) async throws(VaultError) {
            try await client.makeCall(path: basePath + "/mounts/" + (mount?.trim() ?? secretEngine.rawValue), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getConfigFor(secretEngine: Vault.AuthProviderType, mount: String? = nil) async throws(VaultError) -> VaultResponse<BackendConfig> {
            try await client.makeCall(path: basePath + "/mounts/" + (mount?.trim() ?? secretEngine.rawValue) + "/tune", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func writeConfigFor(secretEngine: Vault.AuthProviderType, mount: String? = nil, config: BackendConfig) async throws(VaultError) {
            try await client.makeCall(path: basePath + "/mounts/" + (mount?.trim() ?? secretEngine.rawValue) + "/tune", httpMethod: .post, request: config, wrapTimeToLive: nil)
        }
        
        public func getAllPolicies() async throws(VaultError) -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: basePath + "/policy", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func get(policy: String) async throws(VaultError) -> VaultResponse<Policy> {
            try await client.makeCall(path: basePath + "/policy/" + policy.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func write(policy: Policy) async throws(VaultError) {
            try await client.makeCall(path: basePath + "/policy/" + (policy.name?.trim() ?? ""), httpMethod: .put, request: policy, wrapTimeToLive: nil)
        }
        
        public func delete(policy: String) async throws(VaultError) {
            try await client.makeCall(path: basePath + "/policy/" + policy.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getAllACLPolicies() async throws(VaultError) -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: basePath + "/policyacl/", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func get(aclPolicy: String) async throws(VaultError) -> VaultResponse<ACLPolicy> {
            try await client.makeCall(path: basePath + "/policy/acl/" + aclPolicy.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func write(aclPolicy: ACLPolicy) async throws(VaultError) {
            try await client.makeCall(path: basePath + "/policy/acl/" + (aclPolicy.name?.trim() ?? ""), httpMethod: .put, request: aclPolicy, wrapTimeToLive: nil)
        }
        
        public func delete(aclPolicy: String) async throws(VaultError) {
            try await client.makeCall(path: basePath + "/policy/acl/" + aclPolicy.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
    }
}

public extension Vault {
    enum SystemBackend {}
    
    func buildSystemBackendClient() -> SystemBackend.Client {
        .init(client: client)
    }
}
