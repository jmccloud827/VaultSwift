import Foundation

extension Vault.AuthProviders {
    /// A token provider for the token authentication method.
    struct TokenTokenProvider: TokenProvider {
        let token: String
        
        /// Retrieves the token.
        ///
        /// - Returns: The token string.
        func getToken() throws -> String {
            token
        }
    }
}
