import Foundation

public extension Vault.Kubernetes {
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
        
        // TODO: Implement
            
        public struct Config {
            let mount: String
            let wrapTimeToLive: String?
                
            public init(mount: String?, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount ?? "kubernetes")
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault {
    enum Kubernetes {}
    
    func buildKubernetesClient(config: Kubernetes.Client.Config) -> Kubernetes.Client {
        .init(config: config, client: client)
    }
}
