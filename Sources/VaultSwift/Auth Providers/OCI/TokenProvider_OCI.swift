import Foundation

extension Vault.AuthProviders {
    struct OCITokenProvider: TokenProvider {
        let role: String
        let headers: [String: String]
        let mount: String?
        let client: Vault.Client
        
        func getToken() async throws(VaultError) -> String {
            let request = ["request_headers": headers]
            
            let response: VaultResponse<[String: JSONAny]> = try await client.makeCall(path: "/auth/\(mount?.trim() ?? MethodType.oci.rawValue)/login/\(role)", httpMethod: .post, request: request, wrapTimeToLive: nil)
            
            guard let auth = response.auth else {
                throw .init(error: "Auth was nil")
            }
            
            return auth.clientToken
        }
    }
}
