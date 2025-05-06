import Foundation

public extension Vault.AWS {
    struct RoleResponse: Decodable, Sendable {
        public let roleARNs: [String]?
        public let policyARNs: [String]?
        public let policyDocument: String?
        public let iamGroups: [String]?
        public let iamTags: [String]?
        public let defaultSTSTimeToLive: String?
        public let maximumSTSTimeToLive: String?
        public let userPath: String?
        public let permissionsBoundaryARN: String?
        @available(*, deprecated) public let legacyParameterPolicy: String?
        @available(*, deprecated) public let legacyParameterARN: String?
        public let credentialTypes: [CredentialType]
        
        enum CodingKeys: String, CodingKey {
            case roleARNs = "role_arns"
            case policyARNs = "policy_arns"
            case policyDocument = "policy_document"
            case iamGroups = "iam_groups"
            case iamTags = "iam_tags"
            case defaultSTSTimeToLive = "default_sts_ttl"
            case maximumSTSTimeToLive = "max_sts_ttl"
            case userPath = "user_path"
            case permissionsBoundaryARN = "permissions_boundary_arn"
            case legacyParameterPolicy = "policy"
            case legacyParameterARN = "arn"
            case credentialTypes = "credential_types"
        }
    }
}
