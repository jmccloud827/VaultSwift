import Foundation

public extension Vault.SecretEngines {
    /// A client for interacting with the Vault Transit secret engine.
    struct TransitClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        
        /// Initializes a new `TransitClient` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the Transit client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
        
        /// Initializes a new `TransitClient` instance with the specified configuration and Vault client.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the Transit client.
        ///   - client: The `Vault.Client` instance.
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// This endpoint creates a new named encryption key of the specified type.
        /// The values set here cannot be changed after key creation.
        ///
        /// - Parameters:
        ///   - encryptionKey: The name of the encryption key.
        ///   - options: The `CreateKeyOptions` instance containing the key options.
        /// - Throws: An error if the request fails or the encryption key is empty.
        public func write(encryptionKey: String, options: CreateKeyOptions) async throws {
            guard !encryptionKey.isEmpty else {
                throw VaultError(error: "Encryption Key must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/keys/" + encryptionKey.trim(), httpMethod: .post, request: options, wrapTimeToLive: nil)
        }
        
        /// This endpoint imports existing key material into a new transit-managed encryption key.
        ///
        /// - Parameters:
        ///   - encryptionKey: The name of the encryption key.
        ///   - options: The `ImportKeyOptions` instance containing the import options.
        /// - Throws: An error if the request fails or the encryption key is empty.
        public func `import`(encryptionKey: String, options: ImportKeyOptions) async throws {
            guard !encryptionKey.isEmpty else {
                throw VaultError(error: "Encryption Key must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/keys/" + encryptionKey.trim() + "/import", httpMethod: .post, request: options, wrapTimeToLive: nil)
        }
        
        /// This endpoint imports new key material into an existing imported key.
        ///
        /// - Parameters:
        ///   - encryptionKey: The name of the encryption key.
        ///   - options: The `ImportKeyVersionOptions` instance containing the import options.
        /// - Throws: An error if the request fails or the encryption key is empty.
        public func importVersionFor(encryptionKey: String, options: ImportKeyVersionOptions) async throws {
            guard !encryptionKey.isEmpty else {
                throw VaultError(error: "Encryption Key must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/keys/" + encryptionKey.trim() + "/import-version", httpMethod: .post, request: options, wrapTimeToLive: nil)
        }
        
        /// This endpoint is used to retrieve the wrapping key to use for importing keys.
        /// The returned key will be a 4096-bit RSA public key.
        ///
        /// - Returns: A `VaultResponse` containing the `WrappingKey`.
        /// - Throws: An error if the request fails.
        public func getWrappingKey() async throws -> VaultResponse<WrappingKey> {
            try await client.makeCall(path: config.mount + "/wrapping_key", httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint returns information about a named encryption key.
        ///
        /// - Parameter encryptionKey: The name of the encryption key.
        /// - Returns: A `VaultResponse` containing the encryption key.
        /// - Throws: An error if the request fails or the encryption key is empty.
        public func get<T: Decodable & Sendable>(encryptionKey: String) async throws -> VaultResponse<EncryptionKey<T>> {
            guard !encryptionKey.isEmpty else {
                throw VaultError(error: "Encryption Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/keys/" + encryptionKey.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Returns a list of keys. Only the key names are returned.
        ///
        /// - Returns: A `VaultResponse` containing all encryption keys.
        /// - Throws: An error if the request fails.
        public func getAllEncryptionKeys() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/keys", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint deletes a named encryption key. It will no longer be possible to decrypt any data encrypted with the named key.
        ///
        /// - Parameter encryptionKey: The name of the encryption key.
        /// - Throws: An error if the request fails or the encryption key is empty.
        public func delete(encryptionKey: String) async throws {
            guard !encryptionKey.isEmpty else {
                throw VaultError(error: "Encryption Key must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/keys/" + encryptionKey.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// This endpoint allows tuning configuration values for a given key.
        ///
        /// - Parameters:
        ///   - encryptionKey: The name of the encryption key.
        ///   - config: The `EncryptionKeyConfig` instance containing the configuration options.
        /// - Throws: An error if the request fails or the encryption key is empty.
        public func writeConfigFor(encryptionKey: String, config: EncryptionKeyConfig) async throws {
            guard !encryptionKey.isEmpty else {
                throw VaultError(error: "Encryption Key must not be empty")
            }
            
            try await client.makeCall(path: self.config.mount + "/keys/" + encryptionKey.trim() + "/config", httpMethod: .post, request: config, wrapTimeToLive: nil)
        }
        
        /// This endpoint rotates the version of the named key. After rotation, new plaintext requests will be encrypted with the new version of the key.
        ///
        /// - Parameter encryptionKey: The name of the encryption key.
        /// - Throws: An error if the request fails or the encryption key is empty.
        public func rotate(encryptionKey: String) async throws {
            guard !encryptionKey.isEmpty else {
                throw VaultError(error: "Encryption Key must not be empty")
            }
            
            try await client.makeCall(path: self.config.mount + "/keys/" + encryptionKey.trim() + "/rotate", httpMethod: .post, wrapTimeToLive: nil)
        }
        
        /// This endpoint returns the named key.
        /// The `keys` object shows the value of the key for each version.
        /// If version is specified, the specific version will be returned.
        /// If latest is provided as the version, the current key will be provided.
        /// Depending on the type of key, different information may be returned.
        /// The key must be exportable to support this operation and the version must still be valid.
        ///
        /// - Parameters:
        ///   - encryptionKey: The name of the encryption key.
        ///   - categoryType: The type of key category to export.
        ///   - version: Specifies the version of the key to read. If omitted, all versions of the key will be returned. This is specified as part of the URL. If the version is set to latest, the current key will be returned.
        /// - Returns: A `VaultResponse` containing the exported key.
        /// - Throws: An error if the request fails or the encryption key is empty.
        public func export<T: Decodable & Sendable>(encryptionKey: String, categoryType: KeyCategoryType, version: String? = nil) async throws -> VaultResponse<ExportedKey<T>> {
            guard !encryptionKey.isEmpty else {
                throw VaultError(error: "Encryption Key must not be empty")
            }
            
            let suffix = (version != nil) ? "/" + version! : ""
            
            return try await client.makeCall(path: self.config.mount + "/export/" + "\(categoryType.rawValue)/" + encryptionKey.trim() + suffix, httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Encrypts the provided plaintext using the named key.
        /// This path supports the create and update policy capabilities as follows:
        /// if the user has the create capability for this endpoint in their policies,
        /// and the key does not exist, it will be upserted with default values
        /// (whether the key requires derivation depends on whether the context parameter is empty or not).
        /// If the user only has update capability and the key does not exist, an error will be returned.
        ///
        /// - Parameters:
        ///   - encryptionKey: The name of the encryption key.
        ///   - options: The `EncryptOptions` instance containing the encryption options.
        /// - Returns: A `VaultResponse` containing the encryption response.
        /// - Throws: An error if the request fails or the encryption key is empty.
        public func encrypt(encryptionKey: String, options: EncryptOptions) async throws -> VaultResponse<EncryptResponse> {
            guard !encryptionKey.isEmpty else {
                throw VaultError(error: "Encryption Key must not be empty")
            }
            
            return try await client.makeCall(path: self.config.mount + "/encrypt/" + encryptionKey.trim(), httpMethod: .post, request: options, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Decrypts the provided ciphertext using the named key.
        ///
        /// - Parameters:
        ///   - encryptionKey: The name of the encryption key.
        ///   - options: The `DecryptOptions` instance containing the decryption options.
        /// - Returns: A `VaultResponse` containing the decryption response.
        /// - Throws: An error if the request fails or the encryption key is empty.
        public func decrypt(encryptionKey: String, options: DecryptOptions) async throws -> VaultResponse<DecryptResponse> {
            guard !encryptionKey.isEmpty else {
                throw VaultError(error: "Encryption Key must not be empty")
            }
            
            return try await client.makeCall(path: self.config.mount + "/decrypt/" + encryptionKey.trim(), httpMethod: .post, request: options, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint rewraps the provided ciphertext using the latest version of the named key.
        /// Because this never returns plaintext, it is possible to delegate this functionality to
        /// untrusted users or scripts.
        ///
        /// - Parameters:
        ///   - encryptionKey: The name of the encryption key.
        ///   - options: The `RewrapOptions` instance containing the rewrap options.
        /// - Returns: A `VaultResponse` containing the rewrap response.
        /// - Throws: An error if the request fails or the encryption key is empty.
        public func rewrap(encryptionKey: String, options: RewrapOptions) async throws -> VaultResponse<RewrapResponse> {
            guard !encryptionKey.isEmpty else {
                throw VaultError(error: "Encryption Key must not be empty")
            }
            
            return try await client.makeCall(path: self.config.mount + "/rewrap/" + encryptionKey.trim(), httpMethod: .post, request: options, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint generates a new high-entropy key and the value encrypted with the named key.
        /// Optionally return the plaintext of the key as well.
        /// Whether plaintext is returned depends on the path; as a result, you can use Vault ACL policies to control whether a user is allowed to retrieve the plaintext value of a key.
        /// This is useful if you want an untrusted user or operation to generate keys that are then made available to trusted users.
        ///
        /// - Parameters:
        ///   - encryptionKey: The name of the encryption key.
        ///   - type: The type of data key to generate.
        ///   - options: The `DataKeyOptions` instance containing the data key options.
        /// - Returns: A `VaultResponse` containing the data key response.
        /// - Throws: An error if the request fails or the encryption key is empty.
        public func generateDataKeyFor(encryptionKey: String, type: DataKeyType, options: DataKeyOptions) async throws -> VaultResponse<DataKeyResponse> {
            guard !encryptionKey.isEmpty else {
                throw VaultError(error: "Encryption Key must not be empty")
            }
            
            return try await client.makeCall(path: self.config.mount + "/datakey/" + type.rawValue + "/" + encryptionKey.trim(), httpMethod: .post, request: options, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint returns high-quality random bytes of the specified length.
        ///
        /// - Parameters:
        ///   - sourceType: The source type for generating random bytes (default is `.platform`).
        ///   - request: The `GenerateRandomBytesRequest` instance containing the request options.
        /// - Returns: A `VaultResponse` containing the generated random bytes response.
        /// - Throws: An error if the request fails.
        public func generateRandomBytes(sourceType: RandomBytesSourceType = .platform, request: GenerateRandomBytesRequest) async throws -> VaultResponse<GenerateRandomBytesResponse> {
            try await client.makeCall(path: self.config.mount + "/random/" + sourceType.rawValue, httpMethod: .post, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint returns the cryptographic hash of given data using the specified algorithm.
        ///
        /// - Parameters:
        ///   - type: The hash algorithm type (default is `.sha2_256`).
        ///   - request: The `HashRequest` instance containing the request options.
        /// - Returns: A `VaultResponse` containing the hash response.
        /// - Throws: An error if the request fails.
        public func hash(type: HashAlgorithmType = .sha2_256, request: HashRequest) async throws -> VaultResponse<HashResponse> {
            try await client.makeCall(path: self.config.mount + "/hash/" + type.rawValue, httpMethod: .post, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint returns the digest of given data using the specified hash algorithm
        /// and the named key.
        /// The key can be of any type supported by transit;
        /// the raw key will be marshaled into bytes to be used for the HMAC function.
        /// If the key is of a type that supports rotation, the latest (current) version will be used.
        ///
        /// - Parameters:
        ///   - encryptionKey: The name of the encryption key.
        ///   - hashType: The hash algorithm type (default is `.sha2_256`).
        ///   - request: The `HMACRequest` instance containing the request options.
        /// - Returns: A `VaultResponse` containing the HMAC response.
        /// - Throws: An error if the request fails or the encryption key is empty.
        public func generateHMACFor(encryptionKey: String, hashType: HashAlgorithmType = .sha2_256, request: HMACRequest) async throws -> VaultResponse<HMACResponse> {
            try await client.makeCall(path: self.config.mount + "/hmac/" + encryptionKey.trim() + "/" + hashType.rawValue, httpMethod: .post, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint returns the cryptographic signature of the given data using the
        /// named key and the specified hash algorithm.
        /// The key must be of a type that supports signing.
        ///
        /// - Parameters:
        ///   - encryptionKey: The name of the encryption key.
        ///   - hashType: The hash algorithm type (default is `.sha2_256`).
        ///   - request: The `SignDataRequest` instance containing the request options.
        /// - Returns: A `VaultResponse` containing the sign data response.
        /// - Throws: An error if the request fails or the encryption key is empty.
        public func signDataFor(encryptionKey: String, hashType: HashAlgorithmType = .sha2_256, request: SignDataRequest) async throws -> VaultResponse<SignDataResponse> {
            try await client.makeCall(path: self.config.mount + "/sign/" + encryptionKey.trim() + "/" + hashType.rawValue, httpMethod: .post, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint returns whether the provided signature is valid for the given data.
        ///
        /// - Parameters:
        ///   - encryptionKey: The name of the encryption key.
        ///   - hashType: The hash algorithm type (default is `.sha2_256`).
        ///   - request: The `VerifySignedDataRequest` instance containing the request options.
        /// - Returns: A `VaultResponse` containing the verify signed data response.
        /// - Throws: An error if the request fails or the encryption key is empty.
        public func verifySignedDataFor(encryptionKey: String, hashType: HashAlgorithmType = .sha2_256, request: VerifySignedDataRequest) async throws -> VaultResponse<VerifySignedDataResponse> {
            try await client.makeCall(path: self.config.mount + "/verify/" + encryptionKey.trim() + "/" + hashType.rawValue, httpMethod: .post, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint returns a plaintext backup of a named key.
        /// The backup contains all the configuration data and keys of all the versions
        /// along with the HMAC key.
        /// The response from this endpoint can be used with the restore endpoint to restore the key.
        ///
        /// - Parameter encryptionKey: The name of the encryption key.
        /// - Returns: A `VaultResponse` containing the backup key response.
        /// - Throws: An error if the request fails or the encryption key is empty.
        public func backup(encryptionKey: String) async throws -> VaultResponse<BackupKeyResponse> {
            guard !encryptionKey.isEmpty else {
                throw VaultError(error: "Encryption Key must not be empty")
            }
            
            return try await client.makeCall(path: self.config.mount + "/backup/" + encryptionKey.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// This endpoint restores the backup as a named key.
        /// This will restore the key configurations and all the versions of the named key
        /// along with HMAC keys.
        /// The input to this endpoint should be the output of backup endpoint.
        ///
        /// - Remark: For safety, by default the backend will refuse to restore to an existing key. If you want to reuse a key name, it is recommended you delete the key before restoring. It is a good idea to attempt restoring to a different key name first to verify that the operation successfully completes.
        ///
        /// - Parameters:
        ///   - encryptionKey: The name of the encryption key.
        ///   - request: The `RestoreEncryptionKeyRequest` instance containing the restore options.
        /// - Throws: An error if the request fails.
        public func restore(encryptionKey: String, request: RestoreEncryptionKeyRequest) async throws {
            try await client.makeCall(path: self.config.mount + "/restore" + (encryptionKey.isEmpty ? "" : "/") + encryptionKey.trim(), httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// This endpoint trims older key versions setting a minimum version
        /// for the keyring. Once trimmed, previous versions of the key cannot be recovered.
        ///
        /// - Parameters:
        ///   - encryptionKey: The name of the encryption key.
        ///   - request: The `TrimEncryptionKeyRequest` instance containing the trim options.
        /// - Throws: An error if the request fails or the encryption key is empty.
        public func trim(encryptionKey: String, request: TrimEncryptionKeyRequest) async throws {
            guard !encryptionKey.isEmpty else {
                throw VaultError(error: "Encryption Key must not be empty")
            }
            
            try await client.makeCall(path: self.config.mount + "/keys/" + encryptionKey.trim() + ".trim", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// This endpoint is used to configure the transit engine's cache.
        /// Note that configuration changes will not be applied until the transit plugin
        /// is reloaded which can be achieved using the
        /// reload system backend endpoint.
        ///
        /// - Parameter cacheConfig: The `CacheConfig` instance containing the cache configuration options.
        /// - Throws: An error if the request fails.
        public func write(cacheConfig: CacheConfig) async throws {
            try await client.makeCall(path: self.config.mount + "/cache-config", httpMethod: .post, request: cacheConfig, wrapTimeToLive: nil)
        }
        
        /// This endpoint retrieves configurations for the transit engine's cache.
        ///
        /// - Returns: A `VaultResponse` containing the cache configuration.
        /// - Throws: An error if the request fails.
        public func getCacheConfig() async throws -> VaultResponse<CacheConfig> {
            try await client.makeCall(path: self.config.mount + "/cache-config", httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Configuration for the Transit client.
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
            
            /// Initializes a new `Config` instance for the Transit client.
            ///
            /// - Parameters:
            ///   - mount: The mount path for the Transit engine (default is `transit`).
            ///   - wrapTimeToLive: The wrap time to live for the requests (optional).
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.transit.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    /// Builds a `TransitClient` with the specified configuration.
    ///
    /// - Parameter config: The `TransitClient.Config` instance.
    /// - Returns: A new `TransitClient` instance.
    func buildTransitClient(config: TransitClient.Config) -> TransitClient {
        .init(config: config, client: client)
    }
}
