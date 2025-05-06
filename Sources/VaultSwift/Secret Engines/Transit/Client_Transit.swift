import Foundation

public extension Vault.Transit {
    struct Client {
        private let config: Config
        private let client: Vault.Client
            
        public init(config: Config, vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
            
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
            
        public func write(encryptionKey: String, options: CreateKeyOptions) async throws(VaultError) {
            guard !encryptionKey.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
        
            return try await client.makeCall(path: config.mount + "/keys/" + encryptionKey.trim(), httpMethod: .post, request: options, wrapTimeToLive: nil)
        }
        
        public func `import`(encryptionKey: String, options: ImportKeyOptions) async throws(VaultError) {
            guard !encryptionKey.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
        
            return try await client.makeCall(path: config.mount + "/keys/" + encryptionKey.trim() + "/import", httpMethod: .post, request: options, wrapTimeToLive: nil)
        }
        
        public func importVersionFor(encryptionKey: String, options: ImportKeyVersionOptions) async throws(VaultError) {
            guard !encryptionKey.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
        
            return try await client.makeCall(path: config.mount + "/keys/" + encryptionKey.trim() + "/import-version", httpMethod: .post, request: options, wrapTimeToLive: nil)
        }
        
        public func getWrappingKey() async throws(VaultError) -> VaultResponse<WrappingKey> {
            try await client.makeCall(path: config.mount + "/wrapping_key", httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func get(encryptionKey: String) async throws(VaultError) -> VaultResponse<EncryptionKey> {
            guard !encryptionKey.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
        
            return try await client.makeCall(path: config.mount + "/keys/" + encryptionKey.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func getAllEncryptionKeys() async throws(VaultError) -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/keys", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func delete(encryptionKey: String) async throws(VaultError) {
            guard !encryptionKey.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
        
            try await client.makeCall(path: config.mount + "/keys/" + encryptionKey.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func writeConfigFor(encryptionKey: String, config: EncryptionKeyConfig) async throws(VaultError) {
            guard !encryptionKey.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
        
            try await client.makeCall(path: self.config.mount + "/keys/" + encryptionKey.trim() + "/config", httpMethod: .post, request: config, wrapTimeToLive: nil)
        }
        
        public func rotate(encryptionKey: String) async throws(VaultError) {
            guard !encryptionKey.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
        
            try await client.makeCall(path: self.config.mount + "/keys/" + encryptionKey.trim() + "/rotate", httpMethod: .post, wrapTimeToLive: nil)
        }
        
        public struct Config {
            let mount: String
            let wrapTimeToLive: String?
                
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount ?? SecretEngineType.transit.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault {
    enum Transit {}
    
    func buildTransitClient(config: Transit.Client.Config) -> Transit.Client {
        .init(config: config, client: client)
    }
}
