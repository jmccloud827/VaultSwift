import Foundation

public extension Vault.SecretEngines {
    /// A client for interacting with the Vault TOTP (Time-based One-Time Password) secret engine.
    struct TOTPClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        
        /// Initializes a new `TOTPClient` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the TOTP client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
        
        /// Initializes a new `TOTPClient` instance with the specified configuration and Vault client.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the TOTP client.
        ///   - client: The `Vault.Client` instance.
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// This endpoint creates or updates a key definition.
        ///
        /// - Parameters:
        ///   - key: The name of the key.
        ///   - data: The `CreateKeyRequest` instance containing the key creation data.
        /// - Returns: A `VaultResponse` containing the create key response.
        /// - Throws: An error if the request fails or the key is empty.
        public func write(key: String, data: CreateKeyRequest) async throws -> VaultResponse<CreateKeyResponse> {
            guard !key.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/keys/" + key.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        /// This endpoint creates or updates a key definition.
        ///
        /// - Parameters:
        ///   - key: The name of the key.
        ///   - vaultData: The `CreateKeyRequestVault` instance containing the Vault-specific key creation data.
        /// - Returns: A `VaultResponse` containing the create key response.
        /// - Throws: An error if the request fails or the key is empty.
        public func write(key: String, vaultData: CreateKeyRequestVault) async throws -> VaultResponse<CreateKeyResponse> {
            guard !key.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/keys/" + key.trim(), httpMethod: .post, request: vaultData, wrapTimeToLive: nil)
        }
        
        /// Retrieves a TOTP key.
        ///
        /// - Parameter key: The name of the key.
        /// - Returns: A `VaultResponse` containing the key.
        /// - Throws: An error if the request fails or the key is empty.
        public func get(key: String) async throws -> VaultResponse<Key> {
            guard !key.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/keys/" + key.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Returns a list of available keys. Only the key names are returned, not any values.
        ///
        /// - Returns: A `VaultResponse` containing all keys.
        /// - Throws: An error if the request fails.
        public func getAllKeys() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/keys", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Deletes a TOTP key.
        ///
        /// - Parameter key: The name of the key.
        /// - Throws: An error if the request fails or the key is empty.
        public func delete(key: String) async throws {
            guard !key.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/keys/" + key.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Generates a new time-based one-time use password based on the named key.
        ///
        /// - Parameter key: The name of the key.
        /// - Returns: A `VaultResponse` containing the TOTP code.
        /// - Throws: An error if the request fails or the key is empty.
        public func getCodeFor(key: String) async throws -> VaultResponse<Code> {
            guard !key.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/code/" + key.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Generates a new time-based one-time use password based on the named key.
        ///
        /// - Parameters:
        ///   - code: The TOTP code to validate.
        ///   - key: The name of the key.
        /// - Returns: A `VaultResponse` containing the code validity.
        /// - Throws: An error if the request fails, the code is empty, or the key is empty.
        public func validate(code: String, forKey key: String) async throws -> VaultResponse<CodeValidity> {
            guard !code.isEmpty else {
                throw VaultError(error: "Code must not be empty")
            }
            
            guard !key.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
            
            let request = ["code": code]
            
            return try await client.makeCall(path: config.mount + "/code/" + key.trim(), httpMethod: .post, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Configuration for the TOTP client.
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
            
            /// Initializes a new `Config` instance for the TOTP client.
            ///
            /// - Parameters:
            ///   - mount: The mount path for the TOTP engine (default is `totp`).
            ///   - wrapTimeToLive: The wrap time to live for the requests (optional).
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.totp.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    /// Builds a `TOTPClient` with the specified configuration.
    ///
    /// - Parameter config: The `TOTPClient.Config` instance.
    /// - Returns: A new `TOTPClient` instance.
    func buildTOTPClient(config: TOTPClient.Config) -> TOTPClient {
        .init(config: config, client: client)
    }
}
