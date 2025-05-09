import Foundation

extension Vault.AuthProviders {
    struct CloudFoundryTokenProvider: TokenProvider {
        let request: CloudFoundryAuthRequest
        let mount: String?
        let client: Vault.Client
        
        func getToken() async throws -> String {
            let response: VaultResponse<JSONAny> = try await client.makeCall(path: "v1/auth/\(mount?.trim() ?? MethodType.cloudFoundry.rawValue)/login", httpMethod: .post, request: request, wrapTimeToLive: nil)
            
            guard let auth = response.auth else {
                throw VaultError(error: "Unable to locate token")
            }
            
            return auth.clientToken
        }
    }
    
    public struct CloudFoundryAuthRequest: Encodable {
        public let role: String
        public let instanceCertContent: String
        public let signature: String
        public let signatureDate: String
        
        public init(role: String, instanceCertContent: String, signature: String, signatureDate: Date) {
            self.role = role
            self.instanceCertContent = instanceCertContent
            self.signature = signature
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ssZ"
            self.signatureDate = dateFormatter.string(from: signatureDate)
        }
        
        enum CodingKeys: String, CodingKey {
            case role
            case instanceCertContent = "cf_instance_cert"
            case signature
            case signatureDate = "signing_time"
        }
    }
}
