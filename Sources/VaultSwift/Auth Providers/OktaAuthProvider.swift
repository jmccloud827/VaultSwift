import Foundation

struct OktaAuthProvider: AuthProvider {
    let request: OktaAuthRequest
    let mount: String?
    let client: Vault.Client
        
    func getToken() async throws(VaultError) -> String {
        let response: VaultResponse<[String: JSONAny]> = try await client.makeCall(path: "/auth/\(mount?.trim() ?? AuthProviderType.okta.rawValue)/login/\(request.username)", httpMethod: .post, request: request, wrapTimeToLive: nil)
            
        guard let auth = response.auth else {
            throw .init(error: "Auth was nil")
        }
            
        return auth.clientToken
    }
}

public struct OktaAuthRequest: Encodable {
    public let username: String
    public let password: String
    public let totp: String?
    public let totpProvider: TOTPProvider?
    public let nonce: String?
    
    public init(username: String, password: String, totp: String? = nil, totpProvider: TOTPProvider? = nil, nonce: String? = nil) {
        self.username = username
        self.password = password
        self.totp = totp
        self.totpProvider = totpProvider
        self.nonce = nonce
    }
    
    public enum TOTPProvider: Int {
        case okta
        case google
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(password, forKey: .password)
        try container.encode(totp, forKey: .totp)
        try container.encode(totpProvider?.rawValue, forKey: .totpProvider)
        try container.encode(nonce, forKey: .nonce)
    }
    
    enum CodingKeys: String, CodingKey {
        case password
        case totp
        case totpProvider = "provider"
        case nonce
    }
}
