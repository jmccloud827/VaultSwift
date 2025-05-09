import Foundation

extension Vault.AuthProviders {
    struct AWSTokenProvider: TokenProvider {
        let role: String
        let nonce: String
        let type: AWSAuthMethodType
        let mount: String?
        let client: Vault.Client
        
        func getToken() async throws -> String {
            let request: any BaseRequest =
            switch type {
            case let .ec2(identity: identity, signature: signature):
                EC2Request(role: role, nonce: nonce, identity: identity, signature: signature)
                
            case let .ec2PKCS7(pkcs7: pkcs7):
                EC2PKCS7Request(role: role, nonce: nonce, pkcs7: pkcs7)
                
            case let .iam(url: url, httpMethod: httpMethod, body: body, headers: headers):
                IAMRequest(role: role, nonce: nonce, url: url, httpMethod: httpMethod, body: body, headers: headers)
            }
            
            let response: VaultResponse<JSONAny> = try await client.makeCall(path: "v1/auth/\(mount?.trim() ?? MethodType.aws.rawValue)/login", httpMethod: .post, request: request, wrapTimeToLive: nil)
            
            guard let auth = response.auth else {
                throw VaultError(error: "Unable to locate token")
            }
            
            return auth.clientToken
        }
        
        protocol BaseRequest: Encodable {
            var role: String { get }
            var nonce: String { get }
        }
        
        struct EC2Request: BaseRequest {
            let role: String
            let nonce: String
            let identity: String
            let signature: String
            
            enum CodingKeys: String, CodingKey {
                case identity
                case signature
            }
        }
        
        struct EC2PKCS7Request: BaseRequest {
            let role: String
            let nonce: String
            let pkcs7: String
            
            enum CodingKeys: String, CodingKey {
                case pkcs7
            }
        }
        
        struct IAMRequest: BaseRequest {
            let role: String
            let nonce: String
            let url: String
            let httpMethod: String
            let body: String
            let headers: String
            
            enum CodingKeys: String, CodingKey {
                case url = "iam_request_url"
                case httpMethod = "iam_http_request_method"
                case body = "iam_request_body"
                case headers = "iam_request_headers"
            }
        }
    }
    
    public enum AWSAuthMethodType {
        case ec2(identity: String, signature: String)
        case ec2PKCS7(pkcs7: String)
        case iam(url: String, httpMethod: String, body: String, headers: String)
    }
}
