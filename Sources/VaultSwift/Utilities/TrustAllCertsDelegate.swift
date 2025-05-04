import Foundation

public final class TrustAllCertsDelegate: NSObject, URLSessionDelegate, URLSessionTaskDelegate, Sendable {
    public func urlSession(_: URLSession, didReceive challenge: URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        Self.didReceiveChallenge(challenge: challenge)
    }

    public static func didReceiveChallenge(challenge: URLAuthenticationChallenge) -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            SecTrustSetExceptions(serverTrust, SecTrustCopyExceptions(serverTrust))
            return (.useCredential, URLCredential(trust: serverTrust))
        } else {
            return (.useCredential, nil)
        }
    }
}
