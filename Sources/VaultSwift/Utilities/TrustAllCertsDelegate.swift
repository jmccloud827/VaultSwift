import Foundation

final class TrustAllCertsDelegate: NSObject, URLSessionDelegate, URLSessionTaskDelegate, Sendable {
    func urlSession(_: URLSession, didReceive challenge: URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        Self.didReceiveChallenge(challenge: challenge)
    }

    static func didReceiveChallenge(challenge: URLAuthenticationChallenge) -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            SecTrustSetExceptions(serverTrust, SecTrustCopyExceptions(serverTrust))
            return (.useCredential, URLCredential(trust: serverTrust))
        } else {
            return (.useCredential, nil)
        }
    }
}
