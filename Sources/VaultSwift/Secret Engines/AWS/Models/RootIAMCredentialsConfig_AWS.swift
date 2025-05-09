import Foundation

public extension Vault.SecretEngines.AWSClient {
    struct RootIAMCredentialsConfig: Codable, Sendable {
        public let maxRetries: Int?
        public let accessKey: String?
        public let region: String?
        public let iamEndpoint: String?
        public let stsEndpoint: String?
        public let usernameTemplate: String?
        public let secretKey: String?
        
        public init(maxRetries: Int? = -1,
                    accessKey: String?,
                    region: String?,
                    iamEndpoint: String?,
                    stsEndpoint: String?,
                    usernameTemplate: String?) {
            self.maxRetries = maxRetries
            self.accessKey = accessKey
            self.region = region
            self.iamEndpoint = iamEndpoint
            self.stsEndpoint = stsEndpoint
            self.usernameTemplate = usernameTemplate
            self.secretKey = nil
        }
        
        enum CodingKeys: String, CodingKey {
            case maxRetries = "max_retries"
            case accessKey = "access_key"
            case region
            case iamEndpoint = "iam_endpoint"
            case stsEndpoint = "sts_endpoint"
            case usernameTemplate = "username_template"
            case secretKey = "secret_key"
        }
    }
}
