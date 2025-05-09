import Foundation

public extension Vault.SystemBackend {
    struct MFAClient {
        public lazy var duoClient = DuoClient(client: client)
        public lazy var oktaClient = OktaClient(client: client)
        public lazy var pingIDClient = PingIDClient(client: client)
        public lazy var totpClient = TOTPClient(client: client)
        private let client: Vault.Client
            
        init(client: Vault.Client) {
            self.client = client
        }
        
        public protocol BaseClient {
            var basePath: String { get }
            var client: Vault.Client { get }
            
            associatedtype Config: Codable, Sendable
        }
    }
}

public extension Vault.SystemBackend.MFAClient.BaseClient {
    func write(config: Config, forName name: String) async throws {
        try await client.makeCall(path: basePath + "v1/sys/mfa/method/" + basePath + "/" + name.trim(), httpMethod: .post, request: config, wrapTimeToLive: nil)
    }
    
    func getConfigFor(name: String) async throws -> VaultResponse<Config> {
        try await client.makeCall(path: basePath + "v1/sys/mfa/method/" + basePath + "/" + name.trim(), httpMethod: .get, wrapTimeToLive: nil)
    }
    
    func deleteConfigFor(name: String) async throws {
        try await client.makeCall(path: basePath + "v1/sys/mfa/method/" + basePath + "/" + name.trim(), httpMethod: .delete, wrapTimeToLive: nil)
    }
}
