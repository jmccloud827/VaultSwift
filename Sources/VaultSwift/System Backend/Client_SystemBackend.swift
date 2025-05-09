import Foundation

public extension Vault {
    /// A namespace for system backend-related functionalities.
    enum SystemBackend {}
}

public extension Vault.SystemBackend {
    /// A client for interacting with the system backend of a Vault instance.
    struct Client {
        /// A client for interacting with plugins.
        public lazy var pluginsClient = PluginsClient(client: client)
        
        /// A client for interacting with multi-factor authentication (MFA).
        public lazy var mfaClient = MFAClient(client: client)
        
        /// A client for interacting with enterprise features.
        public lazy var enterpriseClient = EnterpriseClient(client: client)
        
        private let client: Vault.Client
        private let basePath = "v1/sys"
            
        /// Initializes a new `Client` instance with the specified Vault client.
        ///
        /// - Parameter client: The Vault client.
        init(client: Vault.Client) {
            self.client = client
        }
        
        /// Gets all the enabled audit backends (it does not list all available audit backends).
        /// This endpoint requires sudo capability in addition to any path-specific capabilities.
        ///
        /// - Returns: A `VaultResponse` containing a dictionary of audit backends.
        public func getAuditBackends() async throws -> VaultResponse<[String: AuditBackend]> {
            try await client.makeCall(path: basePath + "/audit", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// This endpoint enables a new audit device at the supplied path.
        /// The path can be a single word name or a more complex, nested path.
        ///
        /// - Parameters:
        ///   - auditBackend: The audit backend to mount.
        ///   - mount: An optional mount path.
        public func mount(auditBackend: AuditBackend, mount: String? = nil) async throws {
            try await client.makeCall(path: basePath + "/audit/" + (mount?.trim() ?? auditBackend.type.typeString), httpMethod: .post, request: auditBackend, wrapTimeToLive: nil)
        }
        
        /// Unmounts the audit backend at the given mount point.
        ///
        /// - Parameters:
        ///   - auditBackend: The type of the audit backend to unmount.
        ///   - mount: An optional mount path.
        public func unmount(auditBackend: AuditBackend.`Type`, mount: String? = nil) async throws {
            try await client.makeCall(path: basePath + "/audit/" + (mount?.trim() ?? auditBackend.typeString), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Hash the given input data with the specified audit backend's hash function and salt.
        /// This endpoint can be used to discover whether a given plaintext string (the input parameter) appears in
        /// the audit log in obfuscated form.
        /// Note that the audit log records requests and responses; since the Vault API is JSON-based,
        /// any binary data returned from an API call (such as a DER-format certificate) is base64-encoded by
        /// the Vault server in the response, and as a result such information should also be base64-encoded
        /// to supply into the `input` parameter.
        ///
        /// - Parameters:
        ///   - path: The path for which to retrieve the audit hash.
        ///   - input: The input for which to retrieve the audit hash.
        /// - Returns: A `VaultResponse` containing the audit hash.
        public func auditHashFor(path: String, input: String) async throws -> VaultResponse<AuditHash> {
            let request = ["input": input]
            
            return try await client.makeCall(path: basePath + "/audit-hash/" + path.trim(), httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Gets all the enabled authentication backends.
        ///
        /// - Returns: A `VaultResponse` containing a dictionary of authentication backends.
        public func getAuthBackends<Config: Codable & Sendable, Options: Codable & Sendable>() async throws -> VaultResponse<[String: AuthBackend<Config, Options>]> {
            try await client.makeCall(path: basePath + "/auth", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Mounts a new authentication backend.
        /// The auth backend can be accessed and configured via the auth path specified in the URL.
        ///
        /// - Parameters:
        ///   - authBackend: The authentication backend to mount.
        ///   - mount: An optional mount path.
        public func mount(authBackend: AuthBackend<some Codable & Sendable, some Codable & Sendable>, mount: String? = nil) async throws {
            try await client.makeCall(path: basePath + "/auth/" + (mount?.trim() ?? authBackend.type.rawValue), httpMethod: .post, request: authBackend, wrapTimeToLive: nil)
        }
        
        /// Unmounts the authentication backend at the given mount point.
        ///
        /// - Parameters:
        ///   - authBackend: The type of the authentication backend to unmount.
        ///   - mount: An optional mount path.
        public func unmount(authBackend: Vault.AuthProviders.MethodType, mount: String? = nil) async throws {
            try await client.makeCall(path: basePath + "/auth/" + (mount?.trim() ?? authBackend.rawValue), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Gets the mounted authentication backend's configuration values.
        /// The lease values for each TTL may be the system default ("0" or "system") or a mount-specific value.
        ///
        /// - Parameters:
        ///   - authBackend: The type of the authentication backend.
        ///   - mount: An optional mount path.
        /// - Returns: A `VaultResponse` containing the backend configuration.
        public func getConfigFor(authBackend: Vault.AuthProviders.MethodType, mount: String? = nil) async throws -> VaultResponse<BackendConfig> {
            try await client.makeCall(path: basePath + "/auth/" + (mount?.trim() ?? authBackend.rawValue) + "/tune", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Tunes the mount configuration parameters for the given path.
        ///
        /// - Parameters:
        ///   - authBackend: The type of the authentication backend.
        ///   - mount: An optional mount path.
        ///   - config: The backend configuration to write.
        public func writeConfigFor(authBackend: Vault.AuthProviders.MethodType, mount: String? = nil, config: BackendConfig) async throws {
            try await client.makeCall(path: basePath + "/auth/" + (mount?.trim() ?? authBackend.rawValue) + "/tune", httpMethod: .post, request: config, wrapTimeToLive: nil)
        }
        
        /// Retrieves the capabilities for a given token and path.
        ///
        /// - Parameters:
        ///   - token: The token to check capabilities for.
        ///   - path: The path to check capabilities for.
        /// - Returns: A `VaultResponse` containing the capabilities.
        public func getCapabilitiesFor<T: Decodable & Sendable>(token: String, path: String) async throws -> VaultResponse<T> {
            let request = ["path": path, "token": token]
            
            return try await client.makeCall(path: basePath + "/capabilities", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Retrieves the capabilities for a given token accessor and path.
        ///
        /// - Parameters:
        ///   - tokenAccessor: The token accessor to check capabilities for.
        ///   - path: The path to check capabilities for.
        /// - Returns: A `VaultResponse` containing the capabilities.
        public func getCapabilitiesFor<T: Decodable & Sendable>(tokenAccessor: String, path: String) async throws -> VaultResponse<T> {
            let request = ["path": path, "accessor": tokenAccessor]
            
            return try await client.makeCall(path: basePath + "/capabilities-accessor", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Retrieves the capabilities for the calling token and path.
        ///
        /// - Parameter path: The path to check capabilities for.
        /// - Returns: A `VaultResponse` containing the capabilities.
        public func getCallingTokenCapabilitiesFor<T: Decodable & Sendable>(path: String) async throws -> VaultResponse<T> {
            let request = ["path": path]
            
            return try await client.makeCall(path: basePath + "/capabilities-self", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Retrieves all audit request headers.
        ///
        /// - Returns: A `VaultResponse` containing the request header list.
        public func getAllAuditRequestHeaders() async throws -> VaultResponse<RequestHeaderList> {
            try await client.makeCall(path: basePath + "/config/auditing/request-headers", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Retrieves a specific audit request header.
        ///
        /// - Parameter auditRequestHeader: The audit request header to retrieve.
        /// - Returns: A `VaultResponse` containing the request header list.
        public func get(auditRequestHeader: String) async throws -> VaultResponse<RequestHeaderList> {
            try await client.makeCall(path: basePath + "/config/auditing/request-headers/" + auditRequestHeader, httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Writes a specific audit request header.
        ///
        /// - Parameters:
        ///   - auditRequestHeader: The audit request header to write.
        ///   - hmac: Indicates whether to use HMAC.
        public func write(auditRequestHeader: String, hmac: Bool = false) async throws {
            let request = ["hmac": hmac]
            
            try await client.makeCall(path: basePath + "/config/auditing/request-headers/" + auditRequestHeader, httpMethod: .put, request: request, wrapTimeToLive: nil)
        }
        
        /// Deletes a specific audit request header.
        ///
        /// - Parameter auditRequestHeader: The audit request header to delete.
        public func delete(auditRequestHeader: String) async throws {
            try await client.makeCall(path: basePath + "/config/auditing/request-headers/" + auditRequestHeader, httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Retrieves the CORS configuration.
        ///
        /// - Returns: A `VaultResponse` containing the CORS configuration.
        public func getCORSConfig() async throws -> VaultResponse<CORSConfig> {
            try await client.makeCall(path: basePath + "/config/cors", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Writes the CORS configuration.
        ///
        /// - Parameter corsConfig: The CORS configuration to write.
        public func write(corsConfig: CORSConfig) async throws {
            try await client.makeCall(path: basePath + "/config/cors", httpMethod: .put, request: corsConfig, wrapTimeToLive: nil)
        }
        
        /// Deletes the CORS configuration.
        public func deleteCORSConfig() async throws {
            try await client.makeCall(path: basePath + "/config/cors", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Initializes a new root generation attempt.
        /// Only a single root generation attempt can take place at a time.
        /// One (and only one) of `base64EncodedOneTimePassword` or `pgpKey` are required.
        ///
        /// - Parameters:
        ///   - base64EncodedOneTimePassword: A base64-encoded 16-byte value. The raw bytes of the token will be XOR'd with this value before being returned to the final unseal key provider.
        ///   - pgpKey: A base64-encoded PGP public key. The raw bytes of the token will be encrypted with this value before being returned to the final unseal key provider..
        /// - Returns: The status of the root token generation.
        public func startRootTokenGeneration(base64EncodedOneTimePassword: String?, pgpKey: String?) async throws -> RootTokenGenerationStatus {
            let request = [
                "otp": base64EncodedOneTimePassword,
                "pgp_key": pgpKey
            ]
            
            return try await client.makeCall(path: basePath + "/generate-root/attempt", httpMethod: .put, request: request, wrapTimeToLive: nil)
        }
        
        /// Retrieves the status of the root token generation process.
        ///
        /// - Returns: The status of the root token generation.
        public func getRootTokenGenerationStatus() async throws -> RootTokenGenerationStatus {
            try await client.makeCall(path: basePath + "/generate-root/attempt", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Cancels any in-progress root generation attempt.
        /// This clears any progress made.
        /// This must be called to change the OTP or PGP key being used.
        public func cancelRootTokenGeneration() async throws {
            try await client.makeCall(path: basePath + "/generate-root/attempt", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Continues the root generation process.
        /// Enter a single master key share to progress the root generation attempt.
        /// If the threshold number of master key shares is reached,
        /// Vault will complete the root generation and issue the new token.
        /// Otherwise, this API must be called multiple times until that threshold is met.
        /// The attempt nonce must be provided with each call.
        ///
        /// - Parameters:
        ///   - masterShareKey: The master share key.
        ///   - nonce: The nonce.
        /// - Returns: The status of the root token generation.
        public func continueRootTokenGeneration(masterShareKey: String, nonce: String) async throws -> RootTokenGenerationStatus {
            let request = [
                "key": masterShareKey,
                "nonce": nonce
            ]
            
            return try await client.makeCall(path: basePath + "v1/sys/generate-root/update", httpMethod: .put, request: request, wrapTimeToLive: nil)
        }
        
        /// Retrieves the initialization status of the Vault.
        ///
        /// - Returns: A boolean indicating whether the Vault is initialized.
        public func getInitializeStatus() async throws -> Bool {
            let response: [String: Bool] = try await client.makeCall(path: basePath + "/init", httpMethod: .get, wrapTimeToLive: nil)
            
            guard let isInitialized = response.first?.value else {
                throw VaultError(error: "Corrupted response")
            }
            
            return isInitialized
        }
        
        /// Initializes a new Vault. The Vault must not have been previously initialized.
        /// The recovery options, as well as the stored shares option, are only available when using Vault HSM.
        ///
        /// - Parameter options: The initialization options.
        /// - Returns: The master credentials.
        public func initialize(options: InitOptions) async throws -> MasterCredentials {
            try await client.makeCall(path: basePath + "/init", httpMethod: .put, request: options, wrapTimeToLive: nil)
        }
        
        /// Gets information about the current encryption key used by Vault
        ///
        /// - Returns: A `VaultResponse` containing the key status.
        public func getKeyStatus() async throws -> VaultResponse<KeyStatus> {
            try await client.makeCall(path: basePath + "/key-status", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Gets the high availability status and current leader instance of Vault.
        ///
        /// - Returns: The leader status.
        public func getLeader() async throws -> Leader {
            try await client.makeCall(path: basePath + "/leader", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Retrieves a lease by its ID.
        ///
        /// - Parameter lease: The lease ID.
        /// - Returns: A `VaultResponse` containing the lease.
        public func get(lease: String) async throws -> VaultResponse<Lease> {
            let request = ["lease_id": lease]
            
            return try await client.makeCall(path: basePath + "/leases/lookup", httpMethod: .put, request: request, wrapTimeToLive: nil)
        }
        
        /// Retrieves all leases with a given prefix.
        ///
        /// - Parameter prefix: The prefix of the leases.
        /// - Returns: A `VaultResponse` containing the keys of the leases.
        public func getAllLeases(prefix: String) async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: basePath + "/leases/lookup" + prefix.trim() + "/", httpMethod: .list, wrapTimeToLive: nil)
        }
        
        /// Renews a lease.
        ///
        /// - Parameters:
        ///   - lease: The lease ID.
        ///   - incrementSeconds: The increment in seconds.
        /// - Returns: A `VaultResponse` containing the renew lease response.
        public func renew(lease: String, incrementSeconds: Int) async throws -> VaultResponse<RenewLeaseResponse> {
            let request = RenewLeaseRequest(lease: lease, incrementSeconds: incrementSeconds)
            
            return try await client.makeCall(path: basePath + "/leases/renew", httpMethod: .put, request: request, wrapTimeToLive: nil)
        }
        
        /// Revokes a lease.
        ///
        /// - Parameter lease: The lease ID.
        public func revoke(lease: String) async throws {
            let request = ["lease_id": lease]
            
            try await client.makeCall(path: basePath + "/leases/revoke", httpMethod: .put, request: request, wrapTimeToLive: nil)
        }
        
        /// Revokes all secrets or tokens generated under a given prefix immediately.
        /// Unlike `revoke(lease: String)`, this path ignores backend errors encountered during revocation.
        /// This is potentially very dangerous and should only be used in specific emergency situations where
        /// errors in the backend or the connected backend service prevent normal revocation.
        /// By ignoring these errors, Vault abdicates responsibility for ensuring that the issued
        /// credentials or secrets are properly revoked and/or cleaned up.
        /// Access to this endpoint should be tightly controlled.
        ///
        /// - Parameter lease: The lease ID.
        public func forceRevoke(lease: String) async throws {
            try await client.makeCall(path: basePath + "/leases/revoke-force/" + lease.trim() + "/", httpMethod: .put, wrapTimeToLive: nil)
        }
        
        /// Revokes revokes all secrets (via a lease ID prefix) or tokens (via the tokens' path property) generated under a given prefix immediately.
        /// This requires sudo capability and access to it should be tightly controlled as it can be used
        /// to revoke very large numbers of secrets/tokens at once.
        ///
        /// - Parameter prefix: The prefix of the leases.
        public func revokeLease(prefix: String) async throws {
            try await client.makeCall(path: basePath + "/leases/revoke-prefix/" + prefix.trim() + "/", httpMethod: .put, wrapTimeToLive: nil)
        }
        
        /// Retrieves the verbosity level of all loggers.
        ///
        /// - Returns: A `VaultResponse` containing the verbosity levels.
        public func getVerbosityOfAllLoggers<T: Decodable & Sendable>() async throws -> VaultResponse<T> {
            try await client.makeCall(path: basePath + "/loggers", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Retrieves the verbosity level of a specific logger.
        ///
        /// - Parameter logger: The logger to retrieve the verbosity level for.
        /// - Returns: A `VaultResponse` containing the verbosity level.
        public func getVerbosityOf<T: Decodable & Sendable>(logger: String) async throws -> VaultResponse<T> {
            try await client.makeCall(path: basePath + "/loggers/" + logger.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Sets the verbosity level of all loggers.
        ///
        /// - Parameter level: The verbosity level to set.
        public func writeVerbosityOfAllLoggers(level: LogVerbosityLevel) async throws {
            let request = ["level": level]
            
            try await client.makeCall(path: basePath + "/loggers", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Sets the verbosity level of a specific logger.
        ///
        /// - Parameters:
        ///   - logger: The logger to set the verbosity level for.
        ///   - level: The verbosity level to set.
        public func writeVerbosityOf(logger: String, level: LogVerbosityLevel) async throws {
            let request = ["level": level]
            
            try await client.makeCall(path: basePath + "/loggers/" + logger.trim(), httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Reverts the verbosity level of all loggers to the default.
        ///
        /// - Returns: A `VaultResponse` containing the verbosity levels.
        public func revertVerbosityOfAllLoggers<T: Decodable & Sendable>() async throws -> VaultResponse<T> {
            try await client.makeCall(path: basePath + "/loggers", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Reverts the verbosity level of a specific logger to the default.
        ///
        /// - Parameter logger: The logger to revert the verbosity level for.
        /// - Returns: A `VaultResponse` containing the verbosity level.
        public func revertVerbosityOf<T: Decodable & Sendable>(logger: String) async throws -> VaultResponse<T> {
            try await client.makeCall(path: basePath + "/loggers/" + logger.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Retrieves all secret engines.
        ///
        /// - Returns: A `VaultResponse` containing a dictionary of secret engines.
        public func getAllSecretEngines<Config: Codable & Sendable, Options: Codable & Sendable>() async throws -> VaultResponse<[String: SecretEngine<Config, Options>]> {
            try await client.makeCall(path: basePath + "/mounts", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Retrieves a specific secret engine.
        ///
        /// - Parameter secretEngine: The name of the secret engine.
        /// - Returns: A `VaultResponse` containing the secret engine.
        public func get<Config: Codable & Sendable, Options: Codable & Sendable>(secretEngine: String) async throws -> VaultResponse<SecretEngine<Config, Options>> {
            try await client.makeCall(path: basePath + "/mounts/" + secretEngine.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Mounts a secret engine.
        ///
        /// - Parameters:
        ///   - secretEngine: The secret engine to mount.
        ///   - mount: An optional mount path.
        public func mount(secretEngine: SecretEngine<some Codable & Sendable, some Codable & Sendable>, mount: String? = nil) async throws {
            try await client.makeCall(path: basePath + "/mounts/" + (mount?.trim() ?? secretEngine.type.rawValue), httpMethod: .post, request: secretEngine, wrapTimeToLive: nil)
        }
        
        /// Unmounts a secret engine.
        ///
        /// - Parameters:
        ///   - secretEngine: The type of the secret engine to unmount.
        ///   - mount: An optional mount path.
        public func unmount(secretEngine: Vault.SecretEngines.MountType, mount: String? = nil) async throws {
            try await client.makeCall(path: basePath + "/mounts/" + (mount?.trim() ?? secretEngine.rawValue), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Gets the mounted secret backend's configuration values.
        /// Unlike the `get(secretEngine: String)` method,
        /// this will return the current time in seconds for each TTL,
        /// which may be the system default or a mount-specific value.
        ///
        /// - Parameters:
        ///   - secretEngine: The type of the secret engine.
        ///   - mount: An optional mount path.
        /// - Returns: A `VaultResponse` containing the backend configuration.
        public func getConfigFor(secretEngine: Vault.SecretEngines.MountType, mount: String? = nil) async throws -> VaultResponse<BackendConfig> {
            try await client.makeCall(path: basePath + "/mounts/" + (mount?.trim() ?? secretEngine.rawValue) + "/tune", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Writes the configuration for a secret engine.
        ///
        /// - Parameters:
        ///   - secretEngine: The type of the secret engine.
        ///   - mount: An optional mount path.
        ///   - config: The backend configuration to write.
        public func writeConfigFor(secretEngine: Vault.SecretEngines.MountType, mount: String? = nil, config: BackendConfig) async throws {
            try await client.makeCall(path: basePath + "/mounts/" + (mount?.trim() ?? secretEngine.rawValue) + "/tune", httpMethod: .post, request: config, wrapTimeToLive: nil)
        }
        
        /// Retrieves all policies.
        ///
        /// - Returns: A `VaultResponse` containing the keys of the policies.
        public func getAllPolicies() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: basePath + "/policy", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Retrieves a specific policy.
        ///
        /// - Parameter policy: The name of the policy.
        /// - Returns: A `VaultResponse` containing the policy.
        public func get(policy: String) async throws -> VaultResponse<Policy> {
            try await client.makeCall(path: basePath + "/policy/" + policy.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Writes a policy.
        ///
        /// - Parameter policy: The policy to write.
        public func write(policy: Policy) async throws {
            try await client.makeCall(path: basePath + "/policy/" + (policy.name?.trim() ?? ""), httpMethod: .put, request: policy, wrapTimeToLive: nil)
        }
        
        /// Deletes a policy.
        ///
        /// - Parameter policy: The name of the policy.
        public func delete(policy: String) async throws {
            try await client.makeCall(path: basePath + "/policy/" + policy.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Retrieves all ACL policies.
        ///
        /// - Returns: A `VaultResponse` containing the keys of the ACL policies.
        public func getAllACLPolicies() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: basePath + "/policyacl/", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Retrieves a specific ACL policy.
        ///
        /// - Parameter aclPolicy: The name of the ACL policy.
        /// - Returns: A `VaultResponse` containing the ACL policy.
        public func get(aclPolicy: String) async throws -> VaultResponse<ACLPolicy> {
            try await client.makeCall(path: basePath + "/policy/acl/" + aclPolicy.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Adds or updates the ACL policy.
        /// Once a policy is updated, it takes effect immediately to all associated users.
        ///
        /// - Parameter aclPolicy: The ACL policy to write.
        public func write(aclPolicy: ACLPolicy) async throws {
            try await client.makeCall(path: basePath + "/policy/acl/" + (aclPolicy.name?.trim() ?? ""), httpMethod: .put, request: aclPolicy, wrapTimeToLive: nil)
        }
        
        /// Deletes the named ACL policy. This will immediately affect all associated users.
        ///
        /// - Parameter aclPolicy: The name of the ACL policy.
        public func delete(aclPolicy: String) async throws {
            try await client.makeCall(path: basePath + "/policy/acl/" + aclPolicy.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Generates a password using a specified password policy.
        ///
        /// - Parameter passwordPolicy: The name of the password policy.
        /// - Returns: A `VaultResponse` containing the password response.
        public func generatePasswordFor(passwordPolicy: String) async throws -> VaultResponse<PasswordResponse> {
            try await client.makeCall(path: basePath + "/policies/password/" + passwordPolicy.trim() + "/generate", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Retrieves all raw secret keys with a given prefix.
        ///
        /// - Parameter prefix: Raw path in the storage backend and not the logical path that is exposed via the mount system.
        /// - Returns: A `VaultResponse` containing the keys of the raw secrets.
        public func getAllRawSecretKeys(prefix: String) async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: basePath + "/raw/" + prefix.trim() + "/", httpMethod: .list, wrapTimeToLive: nil)
        }
        
        /// Retrieves a specific raw secret.
        ///
        /// - Parameter rawSecret: Raw path in the storage backend and not the logical path that is exposed via the mount system.
        /// - Returns: A `VaultResponse` containing the raw secret.
        public func get<T: Decodable & Sendable>(rawSecret: String) async throws -> VaultResponse<T> {
            try await client.makeCall(path: basePath + "/raw/" + rawSecret.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Writes a raw secret.
        ///
        /// - Parameters:
        ///   - rawSecret: The name of the raw secret.
        ///   - values: The values to write.
        public func write(rawSecret: String, values: some Encodable & Sendable) async throws {
            try await client.makeCall(path: basePath + "/raw/" + rawSecret.trim(), httpMethod: .put, request: values, wrapTimeToLive: nil)
        }
        
        /// Deletes a raw secret.
        ///
        /// - Parameter rawSecret: Raw path in the storage backend and not the logical path that is exposed via the mount system.
        public func delete(rawSecret: String) async throws {
            try await client.makeCall(path: basePath + "/raw/" + rawSecret.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Initiates a new rekey attempt.
        /// Only a single rekey attempt can take place at a time, and changing the parameters of a rekey requires canceling and starting a new rekey.
        /// This is an unauthenticated call and does not need credentials.
        ///
        /// - Parameter options: The rekey request options.
        /// - Returns: The status of the rekey process.
        public func startRekey(options: RekeyRequest) async throws -> RekeyStatus {
            try await client.makeCall(path: basePath + "/rekey/init", httpMethod: .put, request: options, wrapTimeToLive: nil)
        }
        
        /// Gets the configuration and progress of the current rekey attempt.
        /// Information about the new shares to generate and the threshold required for the new shares,
        /// the number of unseal keys provided for this rekey and the required number of unseal keys is returned.
        /// This is an unauthenticated call and does not need credentials.
        ///
        /// - Returns: The status of the rekey process.
        public func getRekeyStatus() async throws -> RekeyStatus {
            try await client.makeCall(path: basePath + "/rekey/init", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Cancels any in-progress rekey. This clears the rekey settings as well as any progress made.
        /// This must be called to change the parameters of the rekey.
        /// This is an unauthenticated call and does not need credentials.
        public func cancelRekey() async throws {
            try await client.makeCall(path: basePath + "/rekey/init", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Continues the rekey process. Enter a single master key share to progress the rekey of the Vault.
        /// If the threshold number of master key shares is reached, Vault will complete the rekey.
        /// Otherwise, this API must be called multiple times until that threshold is met.
        /// This is an unauthenticated call and does not need credentials.
        ///
        /// - Parameters:
        ///   - masterShareKey: The master share key.
        ///   - rekeyNonce: The rekey nonce.
        /// - Returns: The progress of the rekey process.
        public func continueRekey(masterShareKey: String, rekeyNonce: String) async throws -> RekeyProgress {
            let request = ["key": masterShareKey, "nonce": rekeyNonce]
            
            return try await client.makeCall(path: basePath + "/rekey/update", httpMethod: .put, request: request, wrapTimeToLive: nil)
        }
        
        /// Quickly completes the rekey process.
        ///
        /// - Parameters:
        ///   - allMasterShareKeys: All master share keys.
        ///   - rekeyNonce: The rekey nonce.
        /// - Returns: The progress of the rekey process.
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
        
        /// Gets the the backup copy of PGP-encrypted unseal keys.
        /// The returned value is the nonce of the rekey operation and a map of PGP key
        /// fingerprint to hex-encoded PGP-encrypted key.
        ///
        /// - Returns: A `VaultResponse` containing the rekey backup.
        public func getRekeyBackup() async throws -> VaultResponse<RekeyBackup> {
            try await client.makeCall(path: basePath + "/rekey/backup", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Deletes the rekey backup.
        public func deleteRekeyBackup() async throws {
            try await client.makeCall(path: basePath + "/rekey/backup", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Seals the Vault.
        public func seal() async throws {
            try await client.makeCall(path: basePath + "/seal", httpMethod: .put, wrapTimeToLive: nil)
        }
        
        /// Retrieves the seal status of the Vault.
        ///
        /// - Returns: The seal status of the Vault.
        public func getSealStatus() async throws -> SealStatus {
            try await client.makeCall(path: basePath + "/seal-status", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Progresses the unsealing of the Vault.
        /// Enter a single master key share to progress the unsealing of the Vault.
        /// If the threshold number of master key shares is reached, Vault will attempt to unseal the Vault.
        /// Otherwise, this API must be called multiple times until that threshold is met.
        /// Either the masterShareKey or reset parameter must be provided;
        /// if both are provided, reset takes precedence.
        ///
        /// - Parameters:
        ///   - masterShareKey: The master share key.
        ///   - reset: When true, the previously-provided unseal keys are discarded from memory and the unseal process is completely reset. Default value is false. If you make a call with the value as true, it doesn't matter if this call has a valid unused masterShareKey it'll be ignored.
        /// - Returns: The seal status of the Vault.
        public func unseal(masterShareKey: String? = nil, reset: Bool = false) async throws -> SealStatus {
            struct Request: Encodable {
                let masterShareKey: String?
                let reset: Bool
            }
            
            let request = Request(masterShareKey: masterShareKey, reset: reset)
            
            return try await client.makeCall(path: basePath + "/unseal", httpMethod: .put, request: request, wrapTimeToLive: nil)
        }
        
        /// Unseals the Vault in a single call.
        /// Provide all the master keys together.
        ///
        /// - Parameter allMasterShareKeys: All master share keys.
        /// - Returns: The seal status of the Vault.
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
        
        /// Retrieves wrap information for a given token.
        ///
        /// - Parameter token: The token.
        /// - Returns: The wrap information for the token.
        public func getWrapInfoFor(token: String) async throws -> TokenWrapInfo {
            let request = ["token": token]
            
            return try await client.makeCall(path: basePath + "/wrapping/lookup", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Wraps data with a given token.
        ///
        /// - Parameter data: The data to wrap.
        /// - Returns: A `VaultResponse` containing the wrapped data.
        public func wrap<TData: Encodable, TResponse: Decodable>(data: [String: TData]) async throws -> VaultResponse<TResponse> {
            try await client.makeCall(path: basePath + "/wrapping/wrap", httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        /// Returns the original response inside the given wrapping token.
        /// This endpoint provides additional validation checks on the token,
        /// returns the original value on the wire and ensures that the response is properly audit-logged.
        ///
        /// - Parameter token: The token.
        /// - Returns: A `VaultResponse` containing the unwrapped data.
        public func unwrap<TResponse: Decodable>(token: String) async throws -> VaultResponse<TResponse> {
            let request = ["token": token]
            
            return try await client.makeCall(path: basePath + "/wrapping/unwrap", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Rewraps a response-wrapped token; the new token will use the same creation TTL as
        /// the original token and contain the same response.
        /// The old token will be invalidated.
        /// This can be used for long-term storage of a secret in a response-wrapped
        /// token when rotation is a requirement.
        ///
        /// - Parameter token: The token.
        /// - Returns: A `VaultResponse` containing the rewrapped data.
        public func rewrap<TResponse: Decodable>(token: String) async throws -> VaultResponse<TResponse> {
            let request = ["token": token]
            
            return try await client.makeCall(path: basePath + "/wrapping/rewrap", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
    }
}
