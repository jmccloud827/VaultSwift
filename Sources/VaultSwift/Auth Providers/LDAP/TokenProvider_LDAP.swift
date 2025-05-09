import Foundation

extension Vault.AuthProviders {
    /// A token provider for the LDAP (Lightweight Directory Access Protocol) authentication method.
    struct LDAPTokenProvider: TokenProvider {
        let username: String
        let password: String
        let mount: String?
        let client: Vault.Client
        
        /// Retrieves a token using the LDAP authentication method.
        ///
        /// - Returns: A token string.
        /// - Throws: An error if the request fails or the token cannot be located.
        func getToken() async throws -> String {
            let request = ["password": password]
            
            let response: VaultResponse<JSONAny> = try await client.makeCall(path: "/auth/\(mount?.trim() ?? MethodType.ldap.rawValue)/login/\(username)",
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
