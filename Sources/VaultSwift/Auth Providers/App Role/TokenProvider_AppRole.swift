import Foundation

extension Vault.AuthProviders {
    struct AppRoleTokenProvider: TokenProvider {
        let roleID: String
        let secretID: String?
        let mount: String?
        let client: Vault.Client
        
        func getToken() async throws -> String {
            var request = ["role_id": roleID]
            
            if let secretID {
                request["secret_id"] = secretID
            }
            
            let response: VaultResponse<JSONAny> = try await client.makeCall(path: "v1/auth/\(mount?.trim() ?? MethodType.appRole.rawValue)/login", httpMethod: .post, request: request, wrapTimeToLive: nil)
            
            guard let auth = response.auth else {
                throw VaultError(error: "Unable to locate token")
            }
            
            return auth.clientToken
        }
    }
}
