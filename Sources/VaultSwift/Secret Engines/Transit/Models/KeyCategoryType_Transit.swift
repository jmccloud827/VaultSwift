import Foundation

public extension Vault.SecretEngines.TransitClient {
    enum KeyCategoryType: String, Codable, Sendable {
        case encryption = "encryption-key"
        case signing = "signing-key"
        case hmac = "hmac-key"
        case `public` = "public-key"
        case certificateChain = "certificate-chain"
        /// Enterprise only
        case cmac = "cmac-key"
    }
}
