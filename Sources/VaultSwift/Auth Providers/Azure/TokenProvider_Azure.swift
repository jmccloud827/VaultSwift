import Foundation

extension Vault.AuthProviders {
    /// A token provider for the Azure authentication method.
    struct AzureTokenProvider: TokenProvider {
        let request: AzureAuthRequest
        let mount: String?
        let client: Vault.Client
        
        /// Retrieves a token using the Azure authentication method.
        ///
        /// - Returns: A token string.
        /// - Throws: An error if the request fails or the token cannot be located.
        func getToken() async throws -> String {
            let response: VaultResponse<JSONAny> = try await client.makeCall(path: "v1/auth/\(mount?.trim() ?? MethodType.azure.rawValue)/login",
                                                                             httpMethod: .post,
                                                                             request: request,
                                                                             wrapTimeToLive: nil)
            
            guard let auth = response.auth else {
                throw VaultError(error: "Unable to locate token")
            }
            
            return auth.clientToken
        }
    }
    
    /// A request structure for Azure authentication.
    public struct AzureAuthRequest: Encodable {
        public let role: String
        public let jwt: String
        public let subscriptionID: String?
        public let resourceGroupName: String?
        public let virtualMachineName: String?
        public let virtualMachineScaleSetName: String?
        public let resourceID: String?
        
        /// Initializes a new `AzureAuthRequest` instance.
        ///
        /// - Parameters:
        ///   - role: The role for the Azure authentication.
        ///   - jwt: The JSON Web Token (JWT) for the Azure authentication.
        ///   - subscriptionID: The Azure subscription ID (optional).
        ///   - resourceGroupName: The resource group name (optional).
        ///   - virtualMachineName: The virtual machine name (optional).
        ///   - virtualMachineScaleSetName: The virtual machine scale set name (optional).
        ///   - resourceID: The resource ID (optional).
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
