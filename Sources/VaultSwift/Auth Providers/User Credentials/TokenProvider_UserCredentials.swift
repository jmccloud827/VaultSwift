import Foundation

extension Vault.AuthProviders {
    struct UserCredentialsTokenProvider: TokenProvider {
        let username: String
        let password: String
        let mount: String?
        let client: Vault.Client
        
        func getToken() async throws -> String {
            let request = ["password": password]
            
            let response: VaultResponse<JSONAny> = try await client.makeCall(path: "/auth/\(mount?.trim() ?? MethodType.userCredentials.rawValue)/login/\(username)", httpMethod: .post, request: request, wrapTimeToLive: nil)
            
            guard let auth = response.auth else {
                throw VaultError(error: "Unable to locate token")
            }
            
            return auth.clientToken
        }
    }
}
