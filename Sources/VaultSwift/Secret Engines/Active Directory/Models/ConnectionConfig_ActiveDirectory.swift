import Foundation

public extension Vault.SecretEngines.ActiveDirectoryClient {
    struct ConnectionConfig: Codable, Sendable {
        public let bindingDistinguishedName: String?
        public let x509PEMEncodedCertificate: String?
        @available(*, deprecated) public let legacyParameterFormatter: String?
        public let connectionInsecureTLS: Bool?
        public let lastRotationTolerance: Int?
        @available(*, deprecated) public let legacyParameterLength: String?
        public let passwordMaximumTimeToLive: Int?
        public let passwordPolicy: String?
        public let connectionRequestTimeout: Int?
        public let connectionStartTLS: Bool?
        public let tlsMaxVersion: String?
        public let tlsMinVersion: String?
        public let passwordTimeToLive: Int?
        public let upnDomain: String?
        public let connectionURL: String?
        public let userDistinguishedName: String?
        public let bindingPassword: String?
        
        public init(bindingDistinguishedName: String?,
                    x509PEMEncodedCertificate: String?,
                    connectionInsecureTLS: Bool?,
                    lastRotationTolerance: Int?,
                    passwordMaximumTimeToLive: Int?,
                    passwordPolicy: String?,
                    connectionRequestTimeout: Int? = 90,
                    connectionStartTLS: Bool,
                    tlsMaxVersion: String?,
                    tlsMinVersion: String?,
                    passwordTimeToLive: Int?,
                    upnDomain: String?,
                    connectionURL: String?,
                    userDistinguishedName: String?) {
            self.bindingDistinguishedName = bindingDistinguishedName
            self.x509PEMEncodedCertificate = x509PEMEncodedCertificate
            self.legacyParameterFormatter = nil
            self.connectionInsecureTLS = connectionInsecureTLS
            self.lastRotationTolerance = lastRotationTolerance
            self.legacyParameterLength = nil
            self.passwordMaximumTimeToLive = passwordMaximumTimeToLive
            self.passwordPolicy = passwordPolicy
            self.connectionRequestTimeout = connectionRequestTimeout
            self.connectionStartTLS = connectionStartTLS
            self.tlsMaxVersion = tlsMaxVersion
            self.tlsMinVersion = tlsMinVersion
            self.passwordTimeToLive = passwordTimeToLive
            self.upnDomain = upnDomain
            self.connectionURL = connectionURL
            self.userDistinguishedName = userDistinguishedName
            self.bindingPassword = nil
        }
        
        @available(*, deprecated)
        public init(bindingDistinguishedName: String?,
                    x509PEMEncodedCertificate: String?,
                    legacyParameterFormatter: String?,
                    connectionInsecureTLS: Bool?,
                    lastRotationTolerance: Int?,
                    legacyParameterLength: String?,
                    passwordMaximumTimeToLive: Int?,
                    passwordPolicy: String?,
                    connectionRequestTimeout: Int?,
                    connectionStartTLS: Bool?,
                    tlsMaxVersion: String?,
                    tlsMinVersion: String?,
                    passwordTimeToLive: Int?,
                    upnDomain: String?,
                    connectionURL: String?,
                    userDistinguishedName: String?) {
            self.bindingDistinguishedName = bindingDistinguishedName
            self.x509PEMEncodedCertificate = x509PEMEncodedCertificate
            self.legacyParameterFormatter = legacyParameterFormatter
            self.connectionInsecureTLS = connectionInsecureTLS
            self.lastRotationTolerance = lastRotationTolerance
            self.legacyParameterLength = legacyParameterLength
            self.passwordMaximumTimeToLive = passwordMaximumTimeToLive
            self.passwordPolicy = passwordPolicy
            self.connectionRequestTimeout = connectionRequestTimeout
            self.connectionStartTLS = connectionStartTLS
            self.tlsMaxVersion = tlsMaxVersion
            self.tlsMinVersion = tlsMinVersion
            self.passwordTimeToLive = passwordTimeToLive
            self.upnDomain = upnDomain
            self.connectionURL = connectionURL
            self.userDistinguishedName = userDistinguishedName
            self.bindingPassword = nil
        }
        
        enum CodingKeys: String, CodingKey {
            case bindingDistinguishedName = "binddn"
            case x509PEMEncodedCertificate = "certificate"
            case legacyParameterFormatter = "formatter"
            case connectionInsecureTLS = "insecure_tls"
            case lastRotationTolerance = "last_rotation_tolerance"
            case legacyParameterLength = "length"
            case passwordMaximumTimeToLive = "max_ttl"
            case passwordPolicy = "password_policy"
            case connectionRequestTimeout = "request_timeout"
            case connectionStartTLS = "starttls"
            case tlsMaxVersion = "tls_max_version"
            case tlsMinVersion = "tls_min_version"
            case passwordTimeToLive = "ttl"
            case upnDomain = "upndomain"
            case connectionURL = "url"
            case userDistinguishedName = "userdn"
            case bindingPassword = "bindpassword"
        }
    }
}
