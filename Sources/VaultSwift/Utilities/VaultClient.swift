import Foundation

public extension Vault {
    class Client {
        let config: Config
        
        init(config: Config) {
            self.config = config
        }
        
        enum HTTPMethod: String {
            case get = "GET"
            case post = "POST"
            case put = "PUT"
            case delete = "DELETE"
            case patch = "PATCH"
            case list = "LIST"
        }
        
        func makeCall(path: String, httpMethod: HTTPMethod, wrapTimeToLive: String?) async throws {
            _ = try await self.makeCall(path: path, httpMethod: httpMethod, requestData: nil, wrapTimeToLive: wrapTimeToLive)
        }
        
        func makeCall(path: String, httpMethod: HTTPMethod, request: some Encodable, wrapTimeToLive: String?) async throws {
            let requestData = try JSONEncoder().encode(request)
            
            _ = try await self.makeCall(path: path, httpMethod: httpMethod, requestData: requestData, wrapTimeToLive: wrapTimeToLive)
        }
        
        func makeCall<T: Decodable>(path: String, httpMethod: HTTPMethod, wrapTimeToLive: String?) async throws -> T {
            try await self.makeCall(path: path, httpMethod: httpMethod, requestData: nil, wrapTimeToLive: wrapTimeToLive)
        }
        
        func makeCall<T: Decodable>(path: String, httpMethod: HTTPMethod, request: some Encodable, wrapTimeToLive: String?) async throws -> T {
            let requestData = try JSONEncoder().encode(request)
            
            return try await self.makeCall(path: path, httpMethod: httpMethod, requestData: requestData, wrapTimeToLive: wrapTimeToLive)
        }
        
        private func makeCall<T: Decodable>(path: String, httpMethod: HTTPMethod, requestData: Data?, wrapTimeToLive: String?) async throws -> T {
            let responseData = try await self.makeCall(path: path, httpMethod: httpMethod, requestData: requestData, wrapTimeToLive: wrapTimeToLive)
            
            let response = try JSONDecoder().decode(T.self, from: responseData)
            
            return response
        }
        
        private func makeCall(path: String, httpMethod: HTTPMethod, requestData: Data?, wrapTimeToLive: String?) async throws -> Data {
            guard let url = URL(string: "\(config.baseURI)/v1\(path)") else {
                throw VaultError(error: "Tried to build an invalid URL")
            }
            
            var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
            urlRequest.httpMethod = httpMethod.rawValue
            
            if httpMethod == .patch {
                urlRequest.addValue("application/merge-patch+json", forHTTPHeaderField: "Content-Type")
            }
            
            if let requestData {
                urlRequest.httpBody = requestData
            }
            
            if let authProvider = config.authProvider {
                let token = try await authProvider.getToken()
                urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            if let namespace = config.namespace {
                urlRequest.addValue(namespace, forHTTPHeaderField: "X-Vault-Namespace")
            }
            
            if let wrapTimeToLive {
                urlRequest.addValue(wrapTimeToLive, forHTTPHeaderField: "X-Vault-Wrap-TTL")
            }
            
            urlRequest.addValue("true", forHTTPHeaderField: "X-Vault-Request")
            
            let (response, urlResponse) = try await URLSession.shared.data(for: urlRequest, delegate: TrustAllCertsDelegate())
            
            guard let urlResponse = urlResponse as? HTTPURLResponse else {
                throw VaultError(error: "Server gave a non-HTTP Response")
            }
            
            guard urlResponse.statusCode >= 200 && urlResponse.statusCode < 300 else {
                throw VaultError(error: "Server returned a non-2xx status code (\(urlResponse.statusCode))" + " for URL: \(url)", statusCode: urlResponse.statusCode)
            }
            
            return response
        }
    }
}
