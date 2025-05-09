import Foundation

final class TrustAllCertsDelegate: NSObject, URLSessionDelegate, URLSessionTaskDelegate, Sendable {
    /// Handles the URL session's authentication challenge.
    ///
    /// - Parameters:
    ///   - session: The URL session that received the challenge.
    ///   - challenge: The authentication challenge.
    /// - Returns: A tuple containing the disposition and URL credential.
    func urlSession(_: URLSession, didReceive challenge: URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        Self.didReceiveChallenge(challenge: challenge)
    }

    /// Handles the authentication challenge by creating a URL credential that trusts the server's SSL certificate.
    ///
    /// - Parameter challenge: The authentication challenge.
    /// - Returns: A tuple containing the disposition and URL credential.
    static func didReceiveChallenge(challenge: URLAuthenticationChallenge) -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            SecTrustSetExceptions(serverTrust, SecTrustCopyExceptions(serverTrust))
            return (.useCredential, URLCredential(trust: serverTrust))
        } else {
            return (.useCredential, nil)
        }
    }
}
