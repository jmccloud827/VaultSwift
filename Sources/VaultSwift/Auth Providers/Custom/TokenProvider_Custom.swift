import Foundation

extension Vault.AuthProviders {
    /// A custom token provider that allows providing a custom token retrieval method.
    struct CustomTokenProvider: TokenProvider {
        let getToken: () async throws -> String
        
        /// Retrieves a token using a custom token retrieval method.
        ///
        /// - Returns: A token string.
        /// - Throws: An error if the custom token retrieval method fails.
        func getToken() async throws -> String {
            do {
                return try await getToken()
            } catch let error as VaultError {
                throw error
            } catch {
                throw VaultError(error: error.localizedDescription)
            }
        }
    }
}
