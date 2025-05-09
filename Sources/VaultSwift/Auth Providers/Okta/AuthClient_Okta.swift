import Foundation

public extension Vault.AuthProviders {
    struct OktaClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        private let basePath = "v1/auth"
        
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.config = config
            self.client = .init(config: vaultConfig)
        }
        
        init (config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        public func verifyPushChallengeAsync(nonce: String, boundCIDRs: [String]) async throws -> VaultResponse<VerifyPushChallengeResponse> {
            guard !nonce.isEmpty else {
                throw VaultError(error: "Nonce must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/verify/nonce/" + nonce.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public struct Config {
            public let mount: String
                
            public init(mount: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MethodType.okta.rawValue)
            }
        }
    }
}

public extension Vault.AuthProviders {
    func buildOktaClient(config: OktaClient.Config) -> OktaClient {
        .init(config: config, client: client)
    }
}
