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
            case head = "HEAD"
            case put = "PUT"
            case delete = "DELETE"
            case options = "OPTIONS"
            case trace = "TRACE"
            case patch = "PATCH"
            case list = "LIST"
        }
        
        func makeCall(path: String, httpMethod: HTTPMethod, wrapTimeToLive: String?) async throws(VaultError) {
            _ = try await self.makeCall(path: path, httpMethod: httpMethod, requestData: nil, wrapTimeToLive: wrapTimeToLive)
        }
        
        func makeCall(path: String, httpMethod: HTTPMethod, request: some Encodable, wrapTimeToLive: String?) async throws(VaultError) {
            guard let requestData = try? JSONEncoder().encode(request) else {
                throw .init(error: "JSON encode error")
            }
            
            _ = try await self.makeCall(path: path, httpMethod: httpMethod, requestData: requestData, wrapTimeToLive: wrapTimeToLive)
        }
        
        func makeCall<T: Decodable>(path: String, httpMethod: HTTPMethod, wrapTimeToLive: String?) async throws(VaultError) -> T {
            try await self.makeCall(path: path, httpMethod: httpMethod, requestData: nil, wrapTimeToLive: wrapTimeToLive)
        }
        
        func makeCall<T: Decodable>(path: String, httpMethod: HTTPMethod, request: some Encodable, wrapTimeToLive: String?) async throws(VaultError) -> T {
            guard let requestData = try? JSONEncoder().encode(request) else {
                throw .init(error: "JSON encode error")
            }
            
            return try await self.makeCall(path: path, httpMethod: httpMethod, requestData: requestData, wrapTimeToLive: wrapTimeToLive)
        }
        
        private func makeCall<T: Decodable>(path: String, httpMethod: HTTPMethod, requestData: Data?, wrapTimeToLive: String?) async throws(VaultError) -> T {
            let responseData = try await self.makeCall(path: path, httpMethod: httpMethod, requestData: requestData, wrapTimeToLive: wrapTimeToLive)
            
            guard let response = try? JSONDecoder().decode(T.self, from: responseData) else {
                throw VaultError(error: "JSON decode error\nResponse\n\(String(data: responseData, encoding: .utf8) ?? "")")
            }
            
            return response
        }
        
        private func makeCall(path: String, httpMethod: HTTPMethod, requestData: Data?, wrapTimeToLive: String?) async throws(VaultError) -> Data {
            guard let url = URL(string: "\(config.baseURI)/v1\(path)") else {
                throw .init(error: "Tried to build an invalid URL")
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
            
            do {
                let (response, urlResponse) = try await URLSession.shared.data(for: urlRequest, delegate: TrustAllCertsDelegate())
                
                guard let urlResponse = urlResponse as? HTTPURLResponse else {
                    throw VaultError(error: "Server gave a non-HTTP Response")
                }
                
                guard urlResponse.statusCode >= 200 && urlResponse.statusCode < 300 else {
                    throw VaultError(error: "Server returned a non-2xx status code: \(urlResponse.statusCode)", statusCode: urlResponse.statusCode)
                }
                
                return response
            } catch let error as VaultError {
                throw .init(error: error.localizedDescription + "\nURL: \(url)\nRequest:\n\(String(data: requestData ?? Data(), encoding: .utf8) ?? "")", statusCode: error.statusCode)
            } catch {
                throw .init(error: error.localizedDescription)
            }
        }
    }
}
