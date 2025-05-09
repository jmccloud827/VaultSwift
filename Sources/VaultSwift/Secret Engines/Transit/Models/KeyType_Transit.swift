import Foundation

public extension Vault.SecretEngines.TransitClient {
    enum KeyType: String, Codable, Sendable {
        case aes256_gcm96 = "aes256-gcm96"
        case ecdsa_p256 = "ecdsa-p256"
        case aes128_gcm96 = "aes128-gcm96"
        case chacha20_poly1305 = "chacha20-poly1305"
        case ed25519
        case ecdsa_p384 = "ecdsa-p384"
        case ecdsa_p521 = "ecdsa-p521"
        case rsa_2048 = "rsa-2048"
        case rsa_3072 = "rsa-3072"
        case rsa_4096 = "rsa-4096"
        case hmac = "ecdsa-hmac"
    }
}
