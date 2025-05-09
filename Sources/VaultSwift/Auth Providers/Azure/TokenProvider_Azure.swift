import Foundation

extension Vault.AuthProviders {
    struct AzureTokenProvider: TokenProvider {
        let request: AzureAuthRequest
        let mount: String?
        let client: Vault.Client
        
        func getToken() async throws -> String {
            let response: VaultResponse<JSONAny> = try await client.makeCall(path: "v1/auth/\(mount?.trim() ?? MethodType.azure.rawValue)/login", httpMethod: .post, request: request, wrapTimeToLive: nil)
            
            guard let auth = response.auth else {
                throw VaultError(error: "Unable to locate token")
            }
            
            return auth.clientToken
        }
    }
    
    public struct AzureAuthRequest: Encodable {
        public let role: String
        public let jwt: String
        public let subscriptionID: String?
        public let resourceGroupName: String?
        public let virtualMachineName: String?
        public let virtualMachineScaleSetName: String?
        public let resourceID: String?
        
        public init(role: String,
                    jwt: String,
                    subscriptionID: String? = nil,
                    resourceGroupName: String? = nil,
                    virtualMachineName: String? = nil,
                    virtualMachineScaleSetName: String? = nil,
                    resourceID: String? = nil) {
            self.role = role
            self.jwt = jwt
            self.subscriptionID = subscriptionID
            self.resourceGroupName = resourceGroupName
            self.virtualMachineName = virtualMachineName
            self.virtualMachineScaleSetName = virtualMachineScaleSetName
            self.resourceID = resourceID
        }
        
        enum CodingKeys: String, CodingKey {
            case role
            case jwt
            case subscriptionID = "subscription_id"
            case resourceGroupName = "resource_group_name"
            case virtualMachineName = "vm_name"
            case virtualMachineScaleSetName = "vmss_name"
            case resourceID = "resource_id"
        }
    }
}
