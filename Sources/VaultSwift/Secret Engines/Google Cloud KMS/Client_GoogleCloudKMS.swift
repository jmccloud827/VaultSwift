import Foundation

public extension Vault.SecretEngines {
    struct GoogleCloudKMSClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
            
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
            
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        public func encrypt(key: String, options: EncryptRequest) async throws -> VaultResponse<EncryptResponse> {
            guard !key.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/encrypt/" + key.trim(), httpMethod: .post, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func decrypt(key: String, options: DecryptRequest) async throws -> VaultResponse<DecryptResponse> {
            guard !key.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/decrypt/" + key.trim(), httpMethod: .post, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func reEncrypt(key: String, options: ReEncryptRequest) async throws -> VaultResponse<ReEncryptResponse> {
            guard !key.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/reencrypt/" + key.trim(), httpMethod: .post, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func sign(key: String, options: SignRequest) async throws -> VaultResponse<SignResponse> {
            guard !key.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/sign/" + key.trim(), httpMethod: .post, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func verify(key: String, options: VerifyRequest) async throws -> VaultResponse<VerifyResponse> {
            guard !key.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/verify/" + key.trim(), httpMethod: .post, wrapTimeToLive: config.wrapTimeToLive)
        }
            
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
                
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.googleCloudKMS.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    func buildGoogleCloudKMSClient(config: GoogleCloudKMSClient.Config) -> GoogleCloudKMSClient {
        .init(config: config, client: client)
    }
}
