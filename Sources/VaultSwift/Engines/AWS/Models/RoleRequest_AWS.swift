import Foundation

public extension Vault.AWS {
    struct RoleRequest: Encodable, Sendable {
        public let roleARNs: [String]
        public let policyARNs: [String]
        public let policyDocument: String?
        public let iamGroups: [String]
        public let iamTags: [String]
        public let defaultSTSTimeToLive: String?
        public let maximumSTSTimeToLive: String?
        public let userPath: String?
        public let permissionsBoundaryARN: String?
        @available(*, deprecated) public let legacyParameterPolicy: String?
        @available(*, deprecated) public let legacyParameterARN: String?
        public let credentialType: CredentialType
        
        public init(roleARNs: [String],
                    policyARNs: [String],
                    policyDocument: String?,
                    iamGroups: [String],
                    iamTags: [String],
                    defaultSTSTimeToLive: String?,
                    maximumSTSTimeToLive: String?,
                    userPath: String?,
                    permissionsBoundaryARN: String?,
                    credentialType: CredentialType) {
            self.roleARNs = roleARNs
            self.policyARNs = policyARNs
            self.policyDocument = policyDocument
            self.iamGroups = iamGroups
            self.iamTags = iamTags
            self.defaultSTSTimeToLive = defaultSTSTimeToLive
            self.maximumSTSTimeToLive = maximumSTSTimeToLive
            self.userPath = userPath
            self.permissionsBoundaryARN = permissionsBoundaryARN
            self.legacyParameterPolicy = nil
            self.legacyParameterARN = nil
            self.credentialType = credentialType
        }
        
        @available(*, deprecated)
        public init(roleARNs: [String],
                    policyARNs: [String],
                    policyDocument: String?,
                    iamGroups: [String],
                    iamTags: [String],
                    defaultSTSTimeToLive: String?,
                    maximumSTSTimeToLive: String?,
                    userPath: String?,
                    permissionsBoundaryARN: String?,
                    legacyParameterPolicy: String?,
                    legacyParameterARN: String?,
                    credentialType: CredentialType) {
            self.roleARNs = roleARNs
            self.policyARNs = policyARNs
            self.policyDocument = policyDocument
            self.iamGroups = iamGroups
            self.iamTags = iamTags
            self.defaultSTSTimeToLive = defaultSTSTimeToLive
            self.maximumSTSTimeToLive = maximumSTSTimeToLive
            self.userPath = userPath
            self.permissionsBoundaryARN = permissionsBoundaryARN
            self.legacyParameterPolicy = legacyParameterPolicy
            self.legacyParameterARN = legacyParameterARN
            self.credentialType = credentialType
        }
        
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
            case credentialType = "credential_type"
        }
    }
    
    enum CredentialType: String, Codable, Sendable {
        case iamUser = "iam_user"
        case assumedRole = "assumed_role"
        case federationToken = "federation_token"
    }
}
