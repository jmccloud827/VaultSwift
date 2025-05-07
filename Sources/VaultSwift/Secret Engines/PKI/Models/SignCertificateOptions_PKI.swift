import Foundation

public extension Vault.SecretEngines.PKIClient {
    struct SignCertificateOptions: Encodable, Sendable {
        public let commonName: String?
        public let subjectAlternativeNames: String?
        public let ipSubjectAlternativeNames: String?
        public let uriSubjectAlternativeNames: String?
        public let otherSubjectAlternativeNames: String?
        public let timeToLive: Int?
        public let certificateFormat: CertificateFormat?
        public let csr: String?
        public let excludeCommonNameFromSubjectAlternativeNames: Bool?
        public let removeRootsFromChain: Bool?
        
        public init(commonName: String?,
                    subjectAlternativeNames: String?,
                    ipSubjectAlternativeNames: String?,
                    uriSubjectAlternativeNames: String?,
                    otherSubjectAlternativeNames: String?,
                    timeToLive: Int?,
                    certificateFormat: CertificateFormat? = .pem,
                    csr: String?,
                    excludeCommonNameFromSubjectAlternativeNames: Bool?,
                    removeRootsFromChain: Bool?) {
            self.commonName = commonName
            self.subjectAlternativeNames = subjectAlternativeNames
            self.ipSubjectAlternativeNames = ipSubjectAlternativeNames
            self.uriSubjectAlternativeNames = uriSubjectAlternativeNames
            self.otherSubjectAlternativeNames = otherSubjectAlternativeNames
            self.timeToLive = timeToLive
            self.certificateFormat = certificateFormat
            self.csr = csr
            self.excludeCommonNameFromSubjectAlternativeNames = excludeCommonNameFromSubjectAlternativeNames
            self.removeRootsFromChain = removeRootsFromChain
        }
        
        enum CodingKeys: String, CodingKey {
            case commonName = "common_name"
            case subjectAlternativeNames = "alt_names"
            case ipSubjectAlternativeNames = "ip_sans"
            case uriSubjectAlternativeNames = "uri_sans"
            case otherSubjectAlternativeNames = "other_sans"
            case timeToLive = "ttl"
            case certificateFormat = "format"
            case csr
            case excludeCommonNameFromSubjectAlternativeNames = "exclude_cn_from_sans"
            case removeRootsFromChain = "remove_roots_from_chain"
        }
        
        public enum PrivateKeyFormat: String, Encodable, Sendable {
            case empty
            case der
            case pkcs8
        }
    }
}
