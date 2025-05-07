import Foundation

public protocol BackendClient {
    var config: Config { get }
        
    init(config: Config, vaultConfig: Vault.Config)
    
    associatedtype Config
}
