import Foundation

public extension Vault.SecretEngines {
    struct TransitClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
            
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
            
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
            
        public func write(encryptionKey: String, options: CreateKeyOptions) async throws {
            guard !encryptionKey.isEmpty else {
                throw VaultError(error: "Encryption Key must not be empty")
            }
        
            return try await client.makeCall(path: config.mount + "/keys/" + encryptionKey.trim(), httpMethod: .post, request: options, wrapTimeToLive: nil)
        }
        
        public func `import`(encryptionKey: String, options: ImportKeyOptions) async throws {
            guard !encryptionKey.isEmpty else {
                throw VaultError(error: "Encryption Key must not be empty")
            }
        
            return try await client.makeCall(path: config.mount + "/keys/" + encryptionKey.trim() + "/import", httpMethod: .post, request: options, wrapTimeToLive: nil)
        }
        
        public func importVersionFor(encryptionKey: String, options: ImportKeyVersionOptions) async throws {
            guard !encryptionKey.isEmpty else {
                throw VaultError(error: "Encryption Key must not be empty")
            }
        
            return try await client.makeCall(path: config.mount + "/keys/" + encryptionKey.trim() + "/import-version", httpMethod: .post, request: options, wrapTimeToLive: nil)
        }
        
        public func getWrappingKey() async throws -> VaultResponse<WrappingKey> {
            try await client.makeCall(path: config.mount + "/wrapping_key", httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func get<T: Decodable & Sendable>(encryptionKey: String) async throws -> VaultResponse<EncryptionKey<T>> {
            guard !encryptionKey.isEmpty else {
                throw VaultError(error: "Encryption Key must not be empty")
            }
        
            return try await client.makeCall(path: config.mount + "/keys/" + encryptionKey.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func getAllEncryptionKeys() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/keys", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func delete(encryptionKey: String) async throws {
            guard !encryptionKey.isEmpty else {
                throw VaultError(error: "Encryption Key must not be empty")
            }
        
            try await client.makeCall(path: config.mount + "/keys/" + encryptionKey.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func writeConfigFor(encryptionKey: String, config: EncryptionKeyConfig) async throws {
            guard !encryptionKey.isEmpty else {
                throw VaultError(error: "Encryption Key must not be empty")
            }
        
            try await client.makeCall(path: self.config.mount + "/keys/" + encryptionKey.trim() + "/config", httpMethod: .post, request: config, wrapTimeToLive: nil)
        }
        
        public func rotate(encryptionKey: String) async throws {
            guard !encryptionKey.isEmpty else {
                throw VaultError(error: "Encryption Key must not be empty")
            }
        
            try await client.makeCall(path: self.config.mount + "/keys/" + encryptionKey.trim() + "/rotate", httpMethod: .post, wrapTimeToLive: nil)
        }
        
        public func export<T: Decodable & Sendable>(encryptionKey: String, categoryType: KeyCategoryType, version: String? = nil) async throws -> VaultResponse<ExportedKey<T>> {
            guard !encryptionKey.isEmpty else {
                throw VaultError(error: "Encryption Key must not be empty")
            }
            
            let suffix =
            if let version {
                "/" + version
            } else {
                ""
            }
        
            return try await client.makeCall(path: self.config.mount + "/export/" + "\(categoryType.rawValue)/" + encryptionKey.trim() + suffix, httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func encrypt(encryptionKey: String, options: EncryptOptions) async throws -> VaultResponse<EncryptResponse> {
            guard !encryptionKey.isEmpty else {
                throw VaultError(error: "Encryption Key must not be empty")
            }
        
            return try await client.makeCall(path: self.config.mount + "/encrypt/" + encryptionKey.trim(), httpMethod: .post, request: options, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func decrypt(encryptionKey: String, options: DecryptOptions) async throws -> VaultResponse<DecryptResponse> {
            guard !encryptionKey.isEmpty else {
                throw VaultError(error: "Encryption Key must not be empty")
            }
        
            return try await client.makeCall(path: self.config.mount + "/decrypt/" + encryptionKey.trim(), httpMethod: .post, request: options, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func rewrap(encryptionKey: String, options: RewrapOptions) async throws -> VaultResponse<RewrapResponse> {
            guard !encryptionKey.isEmpty else {
                throw VaultError(error: "Encryption Key must not be empty")
            }
        
            return try await client.makeCall(path: self.config.mount + "/rewrap/" + encryptionKey.trim(), httpMethod: .post, request: options, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func generateDataKeyFor(encryptionKey: String, type: DataKeyType, options: DataKeyOptions) async throws -> VaultResponse<DataKeyResponse> {
            guard !encryptionKey.isEmpty else {
                throw VaultError(error: "Encryption Key must not be empty")
            }
        
            return try await client.makeCall(path: self.config.mount + "/datakey/" + type.rawValue + "/" + encryptionKey.trim(), httpMethod: .post, request: options, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func generateRandomBytes(sourceType: RandomBytesSourceType = .platform, request: GenerateRandomBytesRequest) async throws -> VaultResponse<GenerateRandomBytesResponse> {
            try await client.makeCall(path: self.config.mount + "/random/" + sourceType.rawValue, httpMethod: .post, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func hash(type: HashAlgorithmType = .sha2_256, request: HashRequest) async throws -> VaultResponse<HashResponse> {
            try await client.makeCall(path: self.config.mount + "/hash/" + type.rawValue, httpMethod: .post, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func generateHMACFor(encryptionKey: String, hashType: HashAlgorithmType = .sha2_256, request: HMACRequest) async throws -> VaultResponse<HMACResponse> {
            try await client.makeCall(path: self.config.mount + "/hmac/" + encryptionKey.trim() + "/" + hashType.rawValue, httpMethod: .post, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func signDataFor(encryptionKey: String, hashType: HashAlgorithmType = .sha2_256, request: SignDataRequest) async throws -> VaultResponse<SignDataResponse> {
            try await client.makeCall(path: self.config.mount + "/sign/" + encryptionKey.trim() + "/" + hashType.rawValue, httpMethod: .post, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func verifySignedDataFor(encryptionKey: String, hashType: HashAlgorithmType = .sha2_256, request: VerifySignedDataRequest) async throws -> VaultResponse<VerifySignedDataResponse> {
            try await client.makeCall(path: self.config.mount + "/verify/" + encryptionKey.trim() + "/" + hashType.rawValue, httpMethod: .post, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func backup(encryptionKey: String) async throws -> VaultResponse<BackupKeyResponse> {
            guard !encryptionKey.isEmpty else {
                throw VaultError(error: "Encryption Key must not be empty")
            }
            
            return try await client.makeCall(path: self.config.mount + "/backup/" + encryptionKey.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func restore(encryptionKey: String, request: RestoreEncryptionKeyRequest) async throws {
            try await client.makeCall(path: self.config.mount + "/restore" + (encryptionKey.isEmpty ? "" : "/") + encryptionKey.trim(), httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func trim(encryptionKey: String, request: TrimEncryptionKeyRequest) async throws {
            guard !encryptionKey.isEmpty else {
                throw VaultError(error: "Encryption Key must not be empty")
            }
            
            try await client.makeCall(path: self.config.mount + "/keys/" + encryptionKey.trim() + ".trim", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func write(cacheConfig: CacheConfig) async throws {
            try await client.makeCall(path: self.config.mount + "/cache-config", httpMethod: .post, request: cacheConfig, wrapTimeToLive: nil)
        }
        
        public func getCacheConfig() async throws -> VaultResponse<CacheConfig> {
            try await client.makeCall(path: self.config.mount + "/cache-config", httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
                
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.transit.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    func buildTransitClient(config: TransitClient.Config) -> TransitClient {
        .init(config: config, client: client)
    }
}
