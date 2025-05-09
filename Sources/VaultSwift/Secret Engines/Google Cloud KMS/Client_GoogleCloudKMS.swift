import Foundation

public extension Vault.SecretEngines {
    /// A client for interacting with the Vault Google Cloud KMS secret engine.
    struct GoogleCloudKMSClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        
        /// Initializes a new `GoogleCloudKMSClient` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the Google Cloud KMS client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
        
        /// Initializes a new `GoogleCloudKMSClient` instance with the specified configuration and Vault client.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the Google Cloud KMS client.
        ///   - client: The `Vault.Client` instance.
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// This endpoint uses the named encryption key to encrypt arbitrary plaintext string data.
        /// The response will be base64-encoded encrypted ciphertext.
        ///
        /// - Parameters:
        ///   - key: Name of the key in Vault to use for encryption. This key must already exist in Vault and must map back to a Google Cloud KMS key.
        ///   - options: The `EncryptRequest` instance containing the encryption options.
        /// - Returns: A `VaultResponse` containing the encryption response.
        /// - Throws: An error if the request fails or the key is empty.
        public func encrypt(key: String, options: EncryptRequest) async throws -> VaultResponse<EncryptResponse> {
            guard !key.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/encrypt/" + key.trim(), httpMethod: .post, request: options, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint uses the named encryption key to decrypt the ciphertext string.
        /// For symmetric key types, the provided ciphertext must come from a previous invocation of the /encrypt endpoint.
        /// For asymmetric key types, the provided ciphertext must be from the encrypt operation
        /// against the corresponding key version's public key.
        ///
        /// - Parameters:
        ///   - key: Name of the key in Vault to use for encryption. This key must already exist in Vault and must map back to a Google Cloud KMS key.
        ///   - options: The `DecryptRequest` instance containing the decryption options.
        /// - Returns: A `VaultResponse` containing the decryption response.
        /// - Throws: An error if the request fails or the key is empty.
        public func decrypt(key: String, options: DecryptRequest) async throws -> VaultResponse<DecryptResponse> {
            guard !key.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/decrypt/" + key.trim(), httpMethod: .post, request: options, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint uses the named encryption key to re-encrypt the underlying cryptokey to the latest version for this ciphertext without disclosing the original plaintext value to the requestor.
        /// This is similar to "rewrapping" in Vault's transit secrets engine.
        ///
        /// - Parameters:
        ///   - key: Name of the key in Vault to use for encryption. This key must already exist in Vault and must map back to a Google Cloud KMS key.
        ///   - options: The `ReEncryptRequest` instance containing the re-encryption options.
        /// - Returns: A `VaultResponse` containing the re-encryption response.
        /// - Throws: An error if the request fails or the key is empty.
        public func reEncrypt(key: String, options: ReEncryptRequest) async throws -> VaultResponse<ReEncryptResponse> {
            guard !key.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/reencrypt/" + key.trim(), httpMethod: .post, request: options, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint uses the named encryption key to sign digest string data.
        /// The response will include the base64-encoded signature.
        ///
        /// - Parameters:
        ///   - key: Name of the key in Vault to use for encryption. This key must already exist in Vault and must map back to a Google Cloud KMS key.
        ///   - options: The `SignRequest` instance containing the signing options.
        /// - Returns: A `VaultResponse` containing the signing response.
        /// - Throws: An error if the request fails or the key is empty.
        public func sign(key: String, options: SignRequest) async throws -> VaultResponse<SignResponse> {
            guard !key.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/sign/" + key.trim(), httpMethod: .post, request: options, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint uses the named encryption key to verify a signature and digest string data.
        ///
        /// - Parameters:
        ///   - key: Name of the key in Vault to use for encryption. This key must already exist in Vault and must map back to a Google Cloud KMS key.
        ///   - options: The `VerifyRequest` instance containing the verification options.
        /// - Returns: A `VaultResponse` containing the verification response.
        /// - Throws: An error if the request fails or the key is empty.
        public func verify(key: String, options: VerifyRequest) async throws -> VaultResponse<VerifyResponse> {
            guard !key.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/verify/" + key.trim(), httpMethod: .post, request: options, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Configuration for the Google Cloud KMS client.
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
            
            /// Initializes a new `Config` instance for the Google Cloud KMS client.
            ///
            /// - Parameters:
            ///   - mount: The mount path for the Google Cloud KMS engine (default is `google-cloud-kms`).
            ///   - wrapTimeToLive: The wrap time to live for the requests (optional).
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.googleCloudKMS.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    /// Builds a `GoogleCloudKMSClient` with the specified configuration.
    ///
    /// - Parameter config: The `GoogleCloudKMSClient.Config` instance.
    /// - Returns: A new `GoogleCloudKMSClient` instance.
    func buildGoogleCloudKMSClient(config: GoogleCloudKMSClient.Config) -> GoogleCloudKMSClient {
        .init(config: config, client: client)
    }
}
