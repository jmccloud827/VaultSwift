import Foundation

public extension Vault.SecretEngines.KeyValueClient {
    struct V1: BackendClient {
        public let config: Config
        private let client: Vault.Client
        
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
        
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        public func get(secret: String) async throws -> VaultResponse<[String: String]> {
            guard !secret.isEmpty else {
                throw VaultError(error: "Secret must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/" + secret.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func get<T: Decodable>(secret: String) async throws -> VaultResponse<T> {
            guard !secret.isEmpty else {
                throw VaultError(error: "Secret must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/" + secret.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func listSecretPathsFrom(path: String) async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/" + path.trim() + "\(path.isEmpty ? "" : "/")", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func write(secret: String, values: [String: String]) async throws -> VaultResponse<[String: String]> {
            guard !secret.isEmpty else {
                throw VaultError(error: "Secret must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/" + secret.trim(), httpMethod: .post, request: values, wrapTimeToLive: nil)
        }
        
        public func write<T: Encodable>(secret: String, data: T) async throws -> VaultResponse<T> {
            guard !secret.isEmpty else {
                throw VaultError(error: "Secret must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/" + secret.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        public func delete(secret: String) async throws {
            guard !secret.isEmpty else {
                throw VaultError(error: "Secret must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/" + secret.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
            
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? Vault.SecretEngines.MountType.keyValueV1.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    func buildKeyValueClientV1(config: KeyValueClient.V1.Config) -> KeyValueClient.V1 {
        .init(config: config, client: client)
    }
}

public extension Vault.SecretEngines {
    enum KeyValueClient {}
}
