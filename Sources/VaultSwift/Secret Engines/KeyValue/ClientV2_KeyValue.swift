import Foundation

public extension Vault.KeyValue {
    struct ClientV2 {
        private let config: Config
        private let client: Vault.Client
        
        public init(config: Config, vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
        
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        public func write(config: ConfigModel) async throws(VaultError) {
            try await client.makeCall(path: self.config.mount + "/config", httpMethod: .post, request: config, wrapTimeToLive: nil)
        }
        
        public func getConfig() async throws(VaultError) -> VaultResponse<ConfigModel> {
            try await client.makeCall(path: self.config.mount + "/config", httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func get(secret: String) async throws(VaultError) -> VaultResponse<Secret<[String: String]>> {
            guard !secret.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/data/" + secret.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func get<T: Decodable>(secret: String) async throws(VaultError) -> VaultResponse<Secret<T>> {
            guard !secret.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/data/" + secret.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func write(secret: String, data: SecretRequest<some Encodable>) async throws(VaultError) -> VaultResponse<Metadata> {
            guard !secret.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/data/" + secret.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        public func update(secret: String, data: SecretRequest<some Encodable>) async throws(VaultError) -> VaultResponse<Metadata> {
            guard !secret.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/data/" + secret.trim(), httpMethod: .patch, request: data, wrapTimeToLive: nil)
        }
        
        public func getSecretSubkeysFrom(path: String, version: Int? = nil, depth: Int? = nil) async throws(VaultError) -> VaultResponse<Subkeys> {
            guard !path.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            let queryParameters = "?version=\(version ?? 0)&depth=\(depth ?? 0)"
            
            return try await client.makeCall(path: config.mount + "/subkeys/" + path.trim() + queryParameters, httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func delete(secret: String) async throws(VaultError) {
            guard !secret.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/data/" + secret.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func delete(secret: String, versions: [Int]) async throws(VaultError) {
            guard !secret.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            guard !versions.isEmpty else {
                throw .init(error: "At least one version must be provided")
            }
            
            try await client.makeCall(path: config.mount + "/delete/" + secret.trim(), httpMethod: .post, request: ["versions": versions], wrapTimeToLive: nil)
        }
        
        public func undelete(secret: String, versions: [Int]) async throws(VaultError) {
            guard !secret.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            guard !versions.isEmpty else {
                throw .init(error: "At least one version must be provided")
            }
            
            try await client.makeCall(path: config.mount + "/undelete/" + secret.trim(), httpMethod: .post, request: ["versions": versions], wrapTimeToLive: nil)
        }
        
        public func destroy(secret: String, versions: [Int]) async throws(VaultError) {
            guard !secret.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            guard !versions.isEmpty else {
                throw .init(error: "At least one version must be provided")
            }
            
            try await client.makeCall(path: config.mount + "/destroy/" + secret.trim(), httpMethod: .post, request: ["versions": versions], wrapTimeToLive: nil)
        }
        
        public func listSecretPathsFrom(path: String) async throws(VaultError) -> VaultResponse<Vault.Keys> {
            let queryParameters = "?list=true"
            
            return try await client.makeCall(path: config.mount + "/metadata/" + path.trim() + queryParameters, httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func getMetadataFor(secret: String) async throws(VaultError) -> VaultResponse<Metadata> {
            guard !secret.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/metadata/" + secret.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func write(secret: String, metadata: SecretMetadataRequest) async throws(VaultError) -> VaultResponse<FullMetadata> {
            guard !secret.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/metadata/" + secret.trim(), httpMethod: .post, request: metadata, wrapTimeToLive: nil)
        }
        
        public func update(secret: String, metadata: SecretMetadataRequest) async throws(VaultError) -> VaultResponse<FullMetadata> {
            guard !secret.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/metadata/" + secret.trim(), httpMethod: .patch, request: metadata, wrapTimeToLive: nil)
        }
        
        public func deleteMetadataFor(secret: String) async throws(VaultError) -> VaultResponse<FullMetadata> {
            guard !secret.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/metadata/" + secret.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public struct Config {
            let mount: String
            let wrapTimeToLive: String?
            
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount ?? SecretEngineType.keyValueV2.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault {
    func buildKeyValueClientV2(config: KeyValue.ClientV2.Config) -> KeyValue.ClientV2 {
        .init(config: config, client: client)
    }
}
