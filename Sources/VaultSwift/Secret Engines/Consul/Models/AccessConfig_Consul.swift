import Foundation

public extension Vault.Consul {
    struct AccessConfig: Encodable, Sendable {
        public let consulAddressWithPort: String?
        public let urlScheme: String?
        public let x509PEMEncodedServerCertificate: String?
        public let x509PEMEncodedTLSClientCertificate: String?
        public let x509PEMEncodedTLSClientKey: String?
        public let consulToken: String?
        
        public init(consulAddressWithPort: String?,
                    urlScheme: String?,
                    x509PEMEncodedServerCertificate: String?,
                    x509PEMEncodedTLSClientCertificate: String?,
                    x509PEMEncodedTLSClientKey: String?,
                    consulToken: String?) {
            self.consulAddressWithPort = consulAddressWithPort
            self.urlScheme = urlScheme
            self.x509PEMEncodedServerCertificate = x509PEMEncodedServerCertificate
            self.x509PEMEncodedTLSClientCertificate = x509PEMEncodedTLSClientCertificate
            self.x509PEMEncodedTLSClientKey = x509PEMEncodedTLSClientKey
            self.consulToken = consulToken
        }
        
        enum CodingKeys: String, CodingKey {
            case consulAddressWithPort = "address"
            case urlScheme = "scheme"
            case x509PEMEncodedServerCertificate = "ca_cert"
            case x509PEMEncodedTLSClientCertificate = "client_cert"
            case x509PEMEncodedTLSClientKey = "client_key"
            case consulToken = "token"
        }
    }
}
