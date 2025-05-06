import Foundation

public extension Vault.SystemBackend {
    struct Plugins {
        private let client: Vault.Client
        private let basePath = "v1/sys/plugins"
            
        public init(vaultConfig: Vault.Config) {
            self.init(client: .init(config: vaultConfig))
        }
            
        init(client: Vault.Client) {
            self.client = client
        }
        
//        public func getAuditBackends() async throws(VaultError) -> VaultResponse<[String: AuditBackend]> {
//            try await client.makeCall(path: basePath + "/audit", httpMethod: .get, wrapTimeToLive: nil)
//        }
    }
}
