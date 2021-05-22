# APIiProBonus

## About APIiProBonus
____
This package was created for interconnection with the API iProBonus  server

## Installation
____

APIiProBonus must be installed using Swift Package Manager.

1. In Xcode open **File/Swift Packages/Add Package Dependency...** menu. 

2. Copy and paste the package URL:

```
 https://github.com/AtabaevaAlina/APIiProBonus.git
```
## Usage
____

```swift
    import APIiProBonus // Import the package module

    let info: URL Info? = nil // information about client
    
    // You need to enter client data (client id, device id)
    APIiProBonus.getClientInfo(ClientID: "", DeviceID: "", completion: { data in
        self.info = data // func return information 
    })
```
