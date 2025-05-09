import Foundation

public extension Vault.AuthProviders.OktaClient {
    struct VerifyPushChallengeResponse: Decodable, Sendable {
        public let correctAnswer: Int?

        enum CodingKeys: String, CodingKey {
            case correctAnswer = "correct_answer"
        }
    }
}
