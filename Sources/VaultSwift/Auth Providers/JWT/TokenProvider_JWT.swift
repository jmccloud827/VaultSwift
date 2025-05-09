import Foundation

extension Vault.AuthProviders {
    struct JWTTokenProvider: TokenProvider {
        let role: String
        let jwt: String
        let mount: String?
        let client: Vault.Client
        
        func getToken() async throws -> String {
            let request = ["role": role, "jwt": jwt]
            
            let response: VaultResponse<JSONAny> = try await client.makeCall(path: "v1/auth/\(mount?.trim() ?? MethodType.jwt.rawValue)/login", httpMethod: .post, request: request, wrapTimeToLive: nil)
            
            guard let auth = response.auth else {
                throw VaultError(error: "Unable to locate token")
            }
            
            return auth.clientToken
        }
    }
}
