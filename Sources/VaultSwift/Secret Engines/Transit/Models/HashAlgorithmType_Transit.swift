import Foundation

public extension Vault.SecretEngines.TransitClient {
    enum HashAlgorithmType: String, Sendable {
        @available(*, deprecated) case sha1
        case sha2_224 = "sha2-224"
        case sha2_256 = "sha2-256"
        case sha2_384 = "sha2-384"
        case sha2_512 = "sha2-512"
        case sha3_224 = "sha3-224"
        case sha3_256 = "sha3-256"
        case sha3_384 = "sha3-384"
        case sha3_512 = "sha3-512"
    }
}
