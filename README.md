# Swift Chat!

This tutorial is in progress... The steps you need to follow are very simple, and so they are inline in the code!

Download the code to get started:
```console
git clone https://github.com/exis-io/ExisChatSwift.git
cd ExisChatSwift
pod install
```

### Setup for your app

```console
open /ExisChatSwift/ViewController.swift
```

### Create app on Exis

Navigate to [my.exis.io](my.exis.io) and register for an account or login to your existing 

Click create an app from template and select `SwiftChat`

### Setup for your app

Once you have opened `ExisChatSwift.xcworkspace` navigate to your `ViewController.swift`

Then find:
```swift
app = Domain(name: "xs.demo.USERNAME.swiftchat")

//Copy from: Auth() -> Authorized Key Management -> 'localagent' key
//me.setToken("XXXXXXX")
```

You will replace `USERNAME` in the Domain variable with your username and you will insert your `localagent` key into the `Token` variable
by going to my.exis.io -> Appliances -> Auth -> Token Management -> localagent -> Copy to Clipboard 

**Compile and run!**

