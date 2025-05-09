import Foundation

extension Vault.AuthProviders {
    /// A token provider for the RADIUS authentication method.
    struct RADIUSTokenProvider: TokenProvider {
        let username: String
        let password: String
        let mount: String?
        let client: Vault.Client
        
        /// Retrieves a token using the RADIUS authentication method.
        ///
        /// - Returns: A token string.
        /// - Throws: An error if the request fails or the token cannot be located.
        func getToken() async throws -> String {
            let request = ["password": password]
            
            let response: VaultResponse<JSONAny> = try await client.makeCall(path: "/auth/\(mount?.trim() ?? MethodType.radius.rawValue)/login/\(username)",
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
