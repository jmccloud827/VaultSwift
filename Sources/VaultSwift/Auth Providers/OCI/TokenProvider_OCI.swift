import Foundation

extension Vault.AuthProviders {
    /// A token provider for the OCI (Oracle Cloud Infrastructure) authentication method.
    struct OCITokenProvider: TokenProvider {
        let role: String
        let headers: [String: String]
        let mount: String?
        let client: Vault.Client
        
        /// Retrieves a token using the OCI authentication method.
        ///
        /// - Returns: A token string.
        /// - Throws: An error if the request fails or the token cannot be located.
        func getToken() async throws -> String {
            let request = ["request_headers": headers]
            
            let response: VaultResponse<JSONAny> = try await client.makeCall(path: "/auth/\(mount?.trim() ?? MethodType.oci.rawValue)/login/\(role)",
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
