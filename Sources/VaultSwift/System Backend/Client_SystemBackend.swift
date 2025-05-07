import Foundation

public extension Vault.SystemBackend {
    struct Client {
        public let pluginsClient: PluginsClient
        public let mfaClient: MFAClient
        public let enterpriseClient: EnterpriseClient
        private let client: Vault.Client
        private let basePath = "v1/sys"
            
        init(client: Vault.Client) {
            self.pluginsClient = .init(client: client)
            self.enterpriseClient = .init(client: client)
            self.mfaClient = .init(client: client)
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
        
        public func unmount(authBackend: Vault.AuthProviders.MethodType, mount: String? = nil) async throws(VaultError) {
            try await client.makeCall(path: basePath + "/auth/" + (mount?.trim() ?? authBackend.rawValue), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getConfigFor(authBackend: Vault.AuthProviders.MethodType, mount: String? = nil) async throws(VaultError) -> VaultResponse<BackendConfig> {
            try await client.makeCall(path: basePath + "/auth/" + (mount?.trim() ?? authBackend.rawValue) + "/tune", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func writeConfigFor(authBackend: Vault.AuthProviders.MethodType, mount: String? = nil, config: BackendConfig) async throws(VaultError) {
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
        
        public func unmount(secretEngine: Vault.SecretEngines.MountType, mount: String? = nil) async throws(VaultError) {
            try await client.makeCall(path: basePath + "/mounts/" + (mount?.trim() ?? secretEngine.rawValue), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getConfigFor(secretEngine: Vault.SecretEngines.MountType, mount: String? = nil) async throws(VaultError) -> VaultResponse<BackendConfig> {
            try await client.makeCall(path: basePath + "/mounts/" + (mount?.trim() ?? secretEngine.rawValue) + "/tune", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func writeConfigFor(secretEngine: Vault.SecretEngines.MountType, mount: String? = nil, config: BackendConfig) async throws(VaultError) {
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
        
        public func generatePasswordFor(passwordPolicy: String) async throws(VaultError) -> VaultResponse<PasswordResponse> {
            try await client.makeCall(path: basePath + "/policies/password/" + passwordPolicy.trim() + "/generate", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func getAllRawSecretKeys(prefix: String) async throws(VaultError) -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: basePath + "/raw/" + prefix.trim() + "/", httpMethod: .list, wrapTimeToLive: nil)
        }
        
        public func get(rawSecret: String) async throws(VaultError) -> VaultResponse<[String: JSONAny]> {
            try await client.makeCall(path: basePath + "/raw/" + rawSecret.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func write(rawSecret: String, values: [String: JSONAny]) async throws(VaultError) {
            try await client.makeCall(path: basePath + "/raw/" + rawSecret.trim(), httpMethod: .put, request: values, wrapTimeToLive: nil)
        }
        
        public func delete(rawSecret: String) async throws(VaultError) {
            try await client.makeCall(path: basePath + "/raw/" + rawSecret.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func startRekey(options: RekeyRequest) async throws(VaultError) -> RekeyStatus {
            try await client.makeCall(path: basePath + "/rekey/init", httpMethod: .put, request: options, wrapTimeToLive: nil)
        }
        
        public func getRekeyStatus() async throws(VaultError) -> RekeyStatus {
            try await client.makeCall(path: basePath + "/rekey/init", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func cancelRekey() async throws(VaultError) {
            try await client.makeCall(path: basePath + "/rekey/init", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func continueRekey(masterShareKey: String, rekeyNonce: String) async throws(VaultError) -> RekeyProgress {
            let request = ["key": masterShareKey, "nonce": rekeyNonce]
            
            return try await client.makeCall(path: basePath + "/rekey/update", httpMethod: .put, request: request, wrapTimeToLive: nil)
        }
        
        public func quickRekey(allMasterShareKeys: [String], rekeyNonce: String) async throws(VaultError) -> RekeyProgress? {
            var response: RekeyProgress? = nil
            
            for key in allMasterShareKeys {
                response = try await continueRekey(masterShareKey: key, rekeyNonce: rekeyNonce)
                
                if response?.complete == true {
                    break
                }
            }
            
            return response
        }
        
        public func getRekeyBackup() async throws(VaultError) -> VaultResponse<RekeyBackup> {
            try await client.makeCall(path: basePath + "/rekey/backup", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func deleteRekeyBackup() async throws(VaultError) {
            try await client.makeCall(path: basePath + "/rekey/backup", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func seal() async throws(VaultError) {
            try await client.makeCall(path: basePath + "/seal", httpMethod: .put, wrapTimeToLive: nil)
        }
        
        public func getSealStatus() async throws(VaultError) -> SealStatus {
            try await client.makeCall(path: basePath + "/seal-status", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func unseal(masterShareKey: String? = nil, reset: Bool = false) async throws(VaultError) -> SealStatus {
            struct Request: Encodable {
                let masterShareKey: String?
                let reset: Bool
            }
            
            let request = Request(masterShareKey: masterShareKey, reset: reset)
            
            return try await client.makeCall(path: basePath + "/unseal", httpMethod: .put, request: request, wrapTimeToLive: nil)
        }
        
        public func quickUnseal(allMasterShareKeys: [String]) async throws(VaultError) -> SealStatus? {
            var response: SealStatus? = nil
            
            for key in allMasterShareKeys {
                response = try await unseal(masterShareKey: key)
                
                if response?.sealed == false {
                    break
                }
            }
            
            return response
        }
        
        public func getWrapInfoFor(token: String) async throws(VaultError) -> TokenWrapInfo {
            let request = ["token": token]
            
            return try await client.makeCall(path: basePath + "/wrapping/lookup", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func wrap<TData: Encodable, TResponse: Decodable>(data: [String: TData]) async throws(VaultError) -> VaultResponse<TResponse> {
            try await client.makeCall(path: basePath + "/wrapping/wrap", httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        public func unwrap<TResponse: Decodable>(token: String) async throws(VaultError) -> VaultResponse<TResponse> {
            let request = ["token": token]
            
            return try await client.makeCall(path: basePath + "/wrapping/unwrap", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func rewrap<TResponse: Decodable>(token: String) async throws(VaultError) -> VaultResponse<TResponse> {
            let request = ["token": token]
            
            return try await client.makeCall(path: basePath + "/wrapping/rewrap", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
    }
}

public extension Vault {
    enum SystemBackend {}
}
