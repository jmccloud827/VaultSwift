# VaultSwift

`VaultSwift` is a Swift package based off [`VaultSharp`](https://github.com/rajanadar/VaultSharp.git). It provides a developer friendly implementation of Hashicorp's Vault Service.

## Features

### Auth Methods

* AliCloud
* App Role
* AWS
* Azure
* Cloud Foundry
* googleCloud
* GitHub
* JWT
* Kubernetes
* LDAP
* OCI
* Okta
* RADIUS
* Token
* User Credentials
* Custom

### Auth Clients

* AliCloud
* App Role
* JWT
* LDAP
* Token

### Secret Engines

* Active Directory
* AliCloud
* AWS
* Azure
* Consul
* Cubbyhole
* Database
* Google Cloud
* Google Cloud KMS
* Identity
* Key Management
* KMIP
* Kubernetes
* MongoDB Atlas
* Nomad
* OpenLDAP
* PKI
* RabbitMQ
* SSH
* Teraform
* TOTP
* Transform
* Transit

### System Backend

* System Backend Client
* Entrprise Client
* MFA Client (Dup, Okta, PingID, TOTP)
* Plugins Client

## Requirements

- Swift 6.0+
- Xcode 12.0+
- iOS 15.0+ / macOS 12+ / watchOS 8+ / tvOS 15+ / visionOS 1+

## Installation

You can add this package to your Xcode project using Swift Package Manager. Follow these steps:

1. Open your Xcode project.
2. Select `File` > `Swift Packages` > `Add Package Dependency`.
3. Enter the repository URL: `https://github.com/jmccloud827/VaultSwift.git`.
4. Choose the version or branch you would like to use.
5. Click `Finish`.

## Usage

### Vault

To use `Vault`, you can create an instance and provide it with your configuration.

```swift
import VaultSwift

let vault = Vault(config: .init(baseURI: vaultURI, namespace: namespace, authProvider: .token(token)))

// System Backend
vault.systemsBackendClient.initialize(options: .init(...))

// Auth Provider
let appRoleClient = vault.authProviders.buildAppRoleClient(config: .init())
let allRoles = try await appRoleClient.getAllRoles()

// Secret Engine
let keyValueClient = vault.secretEngines.buildKeyValueClientV2(config: .init())
let config = try await keyValueClient.getConfig()
```

## License

This package is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
