import Foundation

extension Vault.AuthProviders {
    struct TokenTokenProvider: TokenProvider {
        let token: String
        
        func getToken() throws -> String {
            token
        }
    }
}
