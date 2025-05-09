import Foundation

public extension Vault.SystemBackend {
    struct Client {
        public lazy var pluginsClient = PluginsClient(client: client)
        public lazy var mfaClient = MFAClient(client: client)
        public lazy var enterpriseClient = EnterpriseClient(client: client)
        private let client: Vault.Client
        private let basePath = "v1/sys"
            
        init(client: Vault.Client) {
            self.client = client
        }
        
        public func getAuditBackends() async throws -> VaultResponse<[String: AuditBackend]> {
            try await client.makeCall(path: basePath + "/audit", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func mount(auditBackend: AuditBackend, mount: String? = nil) async throws {
            try await client.makeCall(path: basePath + "/audit/" + (mount?.trim() ?? auditBackend.type.typeString), httpMethod: .post, request: auditBackend, wrapTimeToLive: nil)
        }
        
        public func unmount(auditBackend: AuditBackend.`Type`, mount: String? = nil) async throws {
            try await client.makeCall(path: basePath + "/audit/" + (mount?.trim() ?? auditBackend.typeString), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func auditHashFor(path: String, input: String) async throws -> VaultResponse<AuditHash> {
            let request = ["input": input]
            
            return try await client.makeCall(path: basePath + "/audit-hash/" + path.trim(), httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func getAuthBackends<Config: Codable & Sendable, Options: Codable & Sendable>() async throws -> VaultResponse<[String: AuthBackend<Config, Options>]> {
            try await client.makeCall(path: basePath + "/auth", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func mount<Config: Codable & Sendable, Options: Codable & Sendable>(authBackend: AuthBackend<Config, Options>, mount: String? = nil) async throws {
            try await client.makeCall(path: basePath + "/auth/" + (mount?.trim() ?? authBackend.type.rawValue), httpMethod: .post, request: authBackend, wrapTimeToLive: nil)
        }
        
        public func unmount(authBackend: Vault.AuthProviders.MethodType, mount: String? = nil) async throws {
            try await client.makeCall(path: basePath + "/auth/" + (mount?.trim() ?? authBackend.rawValue), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getConfigFor(authBackend: Vault.AuthProviders.MethodType, mount: String? = nil) async throws -> VaultResponse<BackendConfig> {
            try await client.makeCall(path: basePath + "/auth/" + (mount?.trim() ?? authBackend.rawValue) + "/tune", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func writeConfigFor(authBackend: Vault.AuthProviders.MethodType, mount: String? = nil, config: BackendConfig) async throws {
            try await client.makeCall(path: basePath + "/auth/" + (mount?.trim() ?? authBackend.rawValue) + "/tune", httpMethod: .post, request: config, wrapTimeToLive: nil)
        }
        
        public func getCapabilitiesFor<T: Decodable & Sendable>(token: String, path: String) async throws -> VaultResponse<T> {
            let request = ["path": path, "token": token]
            
            return try await client.makeCall(path: basePath + "/capabilities", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func getCapabilitiesFor<T: Decodable & Sendable>(tokenAccessor: String, path: String) async throws -> VaultResponse<T> {
            let request = ["path": path, "accessor": tokenAccessor]
            
            return try await client.makeCall(path: basePath + "/capabilities-accessor", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func getCallingTokenCapabilitiesFor<T: Decodable & Sendable>(path: String) async throws -> VaultResponse<T> {
            let request = ["path": path]
            
            return try await client.makeCall(path: basePath + "/capabilities-self", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func getAllAuditRequestHeaders() async throws -> VaultResponse<RequestHeaderList> {
            try await client.makeCall(path: basePath + "/config/auditing/request-headers", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func get(auditRequestHeader: String) async throws -> VaultResponse<RequestHeaderList> {
            try await client.makeCall(path: basePath + "/config/auditing/request-headers/" + auditRequestHeader, httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func write(auditRequestHeader: String, hmac: Bool = false) async throws {
            let request = ["hmac": hmac]
            
            try await client.makeCall(path: basePath + "/config/auditing/request-headers/" + auditRequestHeader, httpMethod: .put, request: request, wrapTimeToLive: nil)
        }
        
        public func delete(auditRequestHeader: String) async throws {
            try await client.makeCall(path: basePath + "/config/auditing/request-headers/" + auditRequestHeader, httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getCORSConfig() async throws -> VaultResponse<CORSConfig> {
            try await client.makeCall(path: basePath + "/config/cors", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func write(corsConfig: CORSConfig) async throws {
            try await client.makeCall(path: basePath + "/config/cors", httpMethod: .put, request: corsConfig, wrapTimeToLive: nil)
        }
        
        public func deleteCORSConfig() async throws {
            try await client.makeCall(path: basePath + "/config/cors", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func startRootTokenGeneration(base64EncodedOneTimePassword: String, pgpKey: String) async throws -> RootTokenGenerationStatus {
            let request = [
                "otp": base64EncodedOneTimePassword,
                "pgp_key": pgpKey
            ]
            
            return try await client.makeCall(path: basePath + "/generate-root/attempt", httpMethod: .put, request: request, wrapTimeToLive: nil)
        }
        
        public func getRootTokenGenerationStatus() async throws -> RootTokenGenerationStatus {
            try await client.makeCall(path: basePath + "/generate-root/attempt", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func cancelRootTokenGeneration() async throws {
            try await client.makeCall(path: basePath + "/generate-root/attempt", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func continueRootTokenGeneration(masterShareKey: String, nonce: String) async throws -> RootTokenGenerationStatus {
            let request = [
                "key": masterShareKey,
                "nonce": nonce
            ]
            
            return try await client.makeCall(path: basePath + "v1/sys/generate-root/update", httpMethod: .put, request: request, wrapTimeToLive: nil)
        }
        
        public func getInitializeStatus() async throws -> Bool {
            let response: [String: Bool] = try await client.makeCall(path: basePath + "/init", httpMethod: .get, wrapTimeToLive: nil)
            
            guard let isInitialized = response.first?.value else {
                throw VaultError(error: "Corrupted response")
            }
            
            return isInitialized
        }
        
        public func initialize(options: InitOptions) async throws -> MasterCredentials {
            try await client.makeCall(path: basePath + "/init", httpMethod: .put, request: options, wrapTimeToLive: nil)
        }
        
        public func getKeyStatus() async throws -> VaultResponse<KeyStatus> {
            try await client.makeCall(path: basePath + "/key-status", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func getLeader() async throws -> Leader {
            try await client.makeCall(path: basePath + "/leader", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func get(lease: String) async throws -> VaultResponse<Lease> {
            let request = ["lease_id": lease]
            
            return try await client.makeCall(path: basePath + "/leases/lookup", httpMethod: .put, request: request, wrapTimeToLive: nil)
        }
        
        public func getAllLeases(prefix: String) async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: basePath + "/leases/lookup" + prefix.trim() + "/", httpMethod: .list, wrapTimeToLive: nil)
        }
        
        public func renew(lease: String, incrementSeconds: Int) async throws -> VaultResponse<RenewLeaseResponse> {
            let request = RenewLeaseRequest(lease: lease, incrementSeconds: incrementSeconds)
            
            return try await client.makeCall(path: basePath + "/leases/renew", httpMethod: .put, request: request, wrapTimeToLive: nil)
        }
        
        public func revoke(lease: String) async throws {
            let request = ["lease_id": lease]
            
            try await client.makeCall(path: basePath + "/leases/revoke", httpMethod: .put, request: request, wrapTimeToLive: nil)
        }
        
        public func forceRevoke(lease: String) async throws {
            try await client.makeCall(path: basePath + "/leases/revoke-force/" + lease.trim() + "/", httpMethod: .put, wrapTimeToLive: nil)
        }
        
        public func revokeLease(prefix: String) async throws {
            try await client.makeCall(path: basePath + "/leases/revoke-prefix/" + prefix.trim() + "/", httpMethod: .put, wrapTimeToLive: nil)
        }
        
        public func getVerbosityOfAllLoggers<T: Decodable & Sendable>() async throws -> VaultResponse<T> {
            try await client.makeCall(path: basePath + "/loggers", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func getVerbosityOf<T: Decodable & Sendable>(logger: String) async throws -> VaultResponse<T> {
            try await client.makeCall(path: basePath + "/loggers/" + logger.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func writeVerbosityOfAllLoggers(level: LogVerbosityLevel) async throws {
            let request = ["level": level]
            
            try await client.makeCall(path: basePath + "/loggers", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func writeVerbosityOf(logger: String, level: LogVerbosityLevel) async throws {
            let request = ["level": level]
            
            try await client.makeCall(path: basePath + "/loggers/" + logger.trim(), httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func revertVerbosityOfAllLoggers<T: Decodable & Sendable>() async throws -> VaultResponse<T> {
            try await client.makeCall(path: basePath + "/loggers", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func revertVerbosityOf<T: Decodable & Sendable>(logger: String) async throws -> VaultResponse<T> {
            try await client.makeCall(path: basePath + "/loggers/" + logger.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getAllSecretEngines<Config: Codable & Sendable, Options: Codable & Sendable>() async throws -> VaultResponse<[String: SecretEngine<Config, Options>]> {
            try await client.makeCall(path: basePath + "/mounts", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func get<Config: Codable & Sendable, Options: Codable & Sendable>(secretEngine: String) async throws -> VaultResponse<SecretEngine<Config, Options>> {
            try await client.makeCall(path: basePath + "/mounts/" + secretEngine.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func mount<Config: Codable & Sendable, Options: Codable & Sendable>(secretEngine: SecretEngine<Config, Options>, mount: String? = nil) async throws {
            try await client.makeCall(path: basePath + "/mounts/" + (mount?.trim() ?? secretEngine.type.rawValue), httpMethod: .post, request: secretEngine, wrapTimeToLive: nil)
        }
        
        public func unmount(secretEngine: Vault.SecretEngines.MountType, mount: String? = nil) async throws {
            try await client.makeCall(path: basePath + "/mounts/" + (mount?.trim() ?? secretEngine.rawValue), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getConfigFor(secretEngine: Vault.SecretEngines.MountType, mount: String? = nil) async throws -> VaultResponse<BackendConfig> {
            try await client.makeCall(path: basePath + "/mounts/" + (mount?.trim() ?? secretEngine.rawValue) + "/tune", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func writeConfigFor(secretEngine: Vault.SecretEngines.MountType, mount: String? = nil, config: BackendConfig) async throws {
            try await client.makeCall(path: basePath + "/mounts/" + (mount?.trim() ?? secretEngine.rawValue) + "/tune", httpMethod: .post, request: config, wrapTimeToLive: nil)
        }
        
        public func getAllPolicies() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: basePath + "/policy", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func get(policy: String) async throws -> VaultResponse<Policy> {
            try await client.makeCall(path: basePath + "/policy/" + policy.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func write(policy: Policy) async throws {
            try await client.makeCall(path: basePath + "/policy/" + (policy.name?.trim() ?? ""), httpMethod: .put, request: policy, wrapTimeToLive: nil)
        }
        
        public func delete(policy: String) async throws {
            try await client.makeCall(path: basePath + "/policy/" + policy.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getAllACLPolicies() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: basePath + "/policyacl/", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func get(aclPolicy: String) async throws -> VaultResponse<ACLPolicy> {
            try await client.makeCall(path: basePath + "/policy/acl/" + aclPolicy.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func write(aclPolicy: ACLPolicy) async throws {
            try await client.makeCall(path: basePath + "/policy/acl/" + (aclPolicy.name?.trim() ?? ""), httpMethod: .put, request: aclPolicy, wrapTimeToLive: nil)
        }
        
        public func delete(aclPolicy: String) async throws {
            try await client.makeCall(path: basePath + "/policy/acl/" + aclPolicy.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func generatePasswordFor(passwordPolicy: String) async throws -> VaultResponse<PasswordResponse> {
            try await client.makeCall(path: basePath + "/policies/password/" + passwordPolicy.trim() + "/generate", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func getAllRawSecretKeys(prefix: String) async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: basePath + "/raw/" + prefix.trim() + "/", httpMethod: .list, wrapTimeToLive: nil)
        }
        
        public func get<T: Decodable & Sendable>(rawSecret: String) async throws -> VaultResponse<T> {
            try await client.makeCall(path: basePath + "/raw/" + rawSecret.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func write<T: Encodable & Sendable>(rawSecret: String, values: T) async throws {
            try await client.makeCall(path: basePath + "/raw/" + rawSecret.trim(), httpMethod: .put, request: values, wrapTimeToLive: nil)
        }
        
        public func delete(rawSecret: String) async throws {
            try await client.makeCall(path: basePath + "/raw/" + rawSecret.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func startRekey(options: RekeyRequest) async throws -> RekeyStatus {
            try await client.makeCall(path: basePath + "/rekey/init", httpMethod: .put, request: options, wrapTimeToLive: nil)
        }
        
        public func getRekeyStatus() async throws -> RekeyStatus {
            try await client.makeCall(path: basePath + "/rekey/init", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func cancelRekey() async throws {
            try await client.makeCall(path: basePath + "/rekey/init", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func continueRekey(masterShareKey: String, rekeyNonce: String) async throws -> RekeyProgress {
            let request = ["key": masterShareKey, "nonce": rekeyNonce]
            
            return try await client.makeCall(path: basePath + "/rekey/update", httpMethod: .put, request: request, wrapTimeToLive: nil)
        }
        
        public func quickRekey(allMasterShareKeys: [String], rekeyNonce: String) async throws -> RekeyProgress? {
            var response: RekeyProgress? = nil
            
            for key in allMasterShareKeys {
                response = try await continueRekey(masterShareKey: key, rekeyNonce: rekeyNonce)
                
                if response?.complete == true {
                    break
                }
            }
            
            return response
        }
        
        public func getRekeyBackup() async throws -> VaultResponse<RekeyBackup> {
            try await client.makeCall(path: basePath + "/rekey/backup", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func deleteRekeyBackup() async throws {
            try await client.makeCall(path: basePath + "/rekey/backup", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func seal() async throws {
            try await client.makeCall(path: basePath + "/seal", httpMethod: .put, wrapTimeToLive: nil)
        }
        
        public func getSealStatus() async throws -> SealStatus {
            try await client.makeCall(path: basePath + "/seal-status", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func unseal(masterShareKey: String? = nil, reset: Bool = false) async throws -> SealStatus {
            struct Request: Encodable {
                let masterShareKey: String?
                let reset: Bool
            }
            
            let request = Request(masterShareKey: masterShareKey, reset: reset)
            
            return try await client.makeCall(path: basePath + "/unseal", httpMethod: .put, request: request, wrapTimeToLive: nil)
        }
        
        public func quickUnseal(allMasterShareKeys: [String]) async throws -> SealStatus? {
            var response: SealStatus? = nil
            
            for key in allMasterShareKeys {
                response = try await unseal(masterShareKey: key)
                
                if response?.sealed == false {
                    break
                }
            }
            
            return response
        }
        
        public func getWrapInfoFor(token: String) async throws -> TokenWrapInfo {
            let request = ["token": token]
            
            return try await client.makeCall(path: basePath + "/wrapping/lookup", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func wrap<TData: Encodable, TResponse: Decodable>(data: [String: TData]) async throws -> VaultResponse<TResponse> {
            try await client.makeCall(path: basePath + "/wrapping/wrap", httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        public func unwrap<TResponse: Decodable>(token: String) async throws -> VaultResponse<TResponse> {
            let request = ["token": token]
            
            return try await client.makeCall(path: basePath + "/wrapping/unwrap", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func rewrap<TResponse: Decodable>(token: String) async throws -> VaultResponse<TResponse> {
            let request = ["token": token]
            
            return try await client.makeCall(path: basePath + "/wrapping/rewrap", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
    }
}

public extension Vault {
    enum SystemBackend {}
}
