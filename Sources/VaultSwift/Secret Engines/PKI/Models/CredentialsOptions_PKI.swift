import Foundation

public extension Vault.SecretEngines.PKIClient {
    struct CredentialsOptions: Encodable, Sendable {
        public let commonName: String?
        public let subjectAlternativeNames: String?
        public let ipSubjectAlternativeNames: String?
        public let uriSubjectAlternativeNames: String?
        public let otherSubjectAlternativeNames: String?
        public let timeToLive: Int?
        public let certificateFormat: CertificateFormat?
        public let privateKeyFormat: PrivateKeyFormat?
        public let excludeCommonNameFromSubjectAlternativeNames: Bool?
        
        public init(commonName: String?,
                    subjectAlternativeNames: String?,
                    ipSubjectAlternativeNames: String?,
                    uriSubjectAlternativeNames: String?,
                    otherSubjectAlternativeNames: String?,
                    timeToLive: Int?,
                    certificateFormat: CertificateFormat? = .pem,
                    privateKeyFormat: PrivateKeyFormat? = .der,
                    excludeCommonNameFromSubjectAlternativeNames: Bool?) {
            self.commonName = commonName
            self.subjectAlternativeNames = subjectAlternativeNames
            self.ipSubjectAlternativeNames = ipSubjectAlternativeNames
            self.uriSubjectAlternativeNames = uriSubjectAlternativeNames
            self.otherSubjectAlternativeNames = otherSubjectAlternativeNames
            self.timeToLive = timeToLive
            self.certificateFormat = certificateFormat
            self.privateKeyFormat = privateKeyFormat
            self.excludeCommonNameFromSubjectAlternativeNames = excludeCommonNameFromSubjectAlternativeNames
        }
        
        enum CodingKeys: String, CodingKey {
            case commonName = "common_name"
            case subjectAlternativeNames = "alt_names"
            case ipSubjectAlternativeNames = "ip_sans"
            case uriSubjectAlternativeNames = "uri_sans"
            case otherSubjectAlternativeNames = "other_sans"
            case timeToLive = "ttl"
            case certificateFormat = "format"
            case privateKeyFormat = "private_key_format"
            case excludeCommonNameFromSubjectAlternativeNames = "exclude_cn_from_sans"
        }
        
        public enum PrivateKeyFormat: String, Encodable, Sendable {
            case empty
            case der
            case pkcs8
        }
    }
}
