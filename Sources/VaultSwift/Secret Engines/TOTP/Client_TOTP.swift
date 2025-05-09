import Foundation

public extension Vault.SecretEngines {
    struct TOTPClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
            
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
            
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
            
        public func write(key: String, data: CreateKeyRequest) async throws -> VaultResponse<CreateKeyResponse> {
            guard !key.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
        
            return try await client.makeCall(path: config.mount + "/keys/" + key.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        public func write(key: String, vaultData: CreateKeyRequestVault) async throws -> VaultResponse<CreateKeyResponse> {
            guard !key.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
        
            return try await client.makeCall(path: config.mount + "/keys/" + key.trim(), httpMethod: .post, request: vaultData, wrapTimeToLive: nil)
        }
        
        public func get(key: String) async throws -> VaultResponse<Key> {
            guard !key.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
        
            return try await client.makeCall(path: config.mount + "/keys/" + key.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func getAllKeys() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/keys", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func delete(key: String) async throws {
            guard !key.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/keys/" + key.trim(), httpMethod: .list, wrapTimeToLive: nil)
        }
        
        public func getCodeFor(key: String) async throws -> VaultResponse<Code> {
            guard !key.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
        
            return try await client.makeCall(path: config.mount + "/code/" + key.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
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
        
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
                
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.totp.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    func buildTOTPClient(config: TOTPClient.Config) -> TOTPClient {
        .init(config: config, client: client)
    }
}
