import Foundation

extension Vault.AuthProviders {
    /// A token provider for the AppRole authentication method.
    struct AppRoleTokenProvider: TokenProvider {
        let roleID: String
        let secretID: String?
        let mount: String?
        let client: Vault.Client
        
        /// Retrieves a token using the AppRole authentication method.
        ///
        /// - Returns: A token string.
        /// - Throws: An error if the request fails or the token cannot be located.
        func getToken() async throws -> String {
            var request = ["role_id": roleID]
            
            if let secretID {
                request["secret_id"] = secretID
            }
            
            let response: VaultResponse<JSONAny> = try await client.makeCall(path: "v1/auth/\(mount?.trim() ?? MethodType.appRole.rawValue)/login",
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
