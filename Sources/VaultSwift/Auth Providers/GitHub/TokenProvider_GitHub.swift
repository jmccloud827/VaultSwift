import Foundation

extension Vault.AuthProviders {
    /// A token provider for the GitHub authentication method.
    struct GitHubTokenProvider: TokenProvider {
        let personalAccessToken: String
        let mount: String?
        let client: Vault.Client
        
        /// Retrieves a token using the GitHub authentication method.
        ///
        /// - Returns: A token string.
        /// - Throws: An error if the request fails or the token cannot be located.
        func getToken() async throws -> String {
            let request = ["token": personalAccessToken]
            
            let response: VaultResponse<JSONAny> = try await client.makeCall(path: "v1/auth/\(mount?.trim() ?? MethodType.gitHub.rawValue)/login",
                                                                             httpMethod: .post,
                                                                             request: request,
                                                                             wrapTimeToLive: nil)
            
            guard let auth = response.auth else {
                throw VaultError(error: "Unable to locate token")
            }
            
            return auth.clientToken
        }
    }
}
