import Foundation

public extension Vault.SecretEngines {
    struct KMIPClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
            
        public init(config: Config, vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
            
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
            
        public func getCredentialsFor(role: String, scope: String, certificateFormat: CertificateFormat) async throws(VaultError) -> VaultResponse<Credentials> {
            guard !role.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            guard !scope.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            let request = ["format": certificateFormat.rawValue]
            
            return try await client.makeCall(path: config.mount + "/scope/" + scope.trim() + "/role/" + role.trim() + "/credential/generate", httpMethod: .post, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public enum CertificateFormat: String {
            case empty
            case der
            case pem
            case pemBundle = "pem_bundle"
        }
        
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
                
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount ?? MountType.kmip.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault {
    func buildKMIPClient(config: SecretEngines.KMIPClient.Config) -> SecretEngines.KMIPClient {
        .init(config: config, client: client)
    }
}
