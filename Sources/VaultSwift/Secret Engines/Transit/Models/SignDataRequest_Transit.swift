import Foundation

public extension Vault.SecretEngines.TransitClient {
    struct SignDataRequest: Encodable, Sendable {
        public let keyVersion: Int?
        public let base64EncodedInput: String?
        public let base64EncodedKeyDerivationContext: String?
        public let preHashed: Bool?
        public let signatureAlgorithm: SignatureAlgorithm?
        public let marshalingAlgorithm: MarshalingAlgorithm?
        public let saltLengthType: SaltLengthType?
        public let batchInput: [Self]?
        
        public init(keyVersion: Int?,
                    base64EncodedInput: String?,
                    base64EncodedKeyDerivationContext: String?,
                    preHashed: Bool?,
                    signatureAlgorithm: SignatureAlgorithm? = .pss,
                    marshalingAlgorithm: MarshalingAlgorithm? = .asn1,
                    saltLengthType: SaltLengthType? = .auto,
                    batchInput: [Self]?) {
            self.keyVersion = keyVersion
            self.base64EncodedInput = base64EncodedInput
            self.base64EncodedKeyDerivationContext = base64EncodedKeyDerivationContext
            self.preHashed = preHashed
            self.signatureAlgorithm = signatureAlgorithm
            self.marshalingAlgorithm = marshalingAlgorithm
            self.saltLengthType = saltLengthType
            self.batchInput = batchInput
        }
        
        enum CodingKeys: String, CodingKey {
            case keyVersion = "key_version"
            case base64EncodedInput = "input"
            case base64EncodedKeyDerivationContext = "context"
            case preHashed = "prehashed"
            case signatureAlgorithm = "signature_algorithm"
            case marshalingAlgorithm = "marshaling_algorithm"
            case saltLengthType = "salt_length"
            case batchInput = "batch_input"
        }
    }
}
