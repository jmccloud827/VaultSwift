import Foundation

public extension Vault.SystemBackend {
    struct MFAClient {
        public let duoClient: DuoClient
        public let oktaClient: OktaClient
        public let pingIDClient: PingIDClient
        public let totpClient: TOTPClient
        private let client: Vault.Client
            
        init(client: Vault.Client) {
            self.duoClient = .init(client: client)
            self.oktaClient = .init(client: client)
            self.pingIDClient = .init(client: client)
            self.totpClient = .init(client: client)
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
    func write(config: Config, forName name: String) async throws(VaultError) {
        try await client.makeCall(path: basePath + "v1/sys/mfa/method/" + basePath + "/" + name.trim(), httpMethod: .post, request: config, wrapTimeToLive: nil)
    }
    
    func getConfigFor(name: String) async throws(VaultError) -> VaultResponse<Config> {
        try await client.makeCall(path: basePath + "v1/sys/mfa/method/" + basePath + "/" + name.trim(), httpMethod: .get, wrapTimeToLive: nil)
    }
    
    func deleteConfigFor(name: String) async throws(VaultError) {
        try await client.makeCall(path: basePath + "v1/sys/mfa/method/" + basePath + "/" + name.trim(), httpMethod: .delete, wrapTimeToLive: nil)
    }
}
