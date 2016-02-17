# ProjectNingIOS
SDK project and a sample app built over the SDK.

To use this SDK, please import PNService.h in your .h file to access all the methodes in the SDK

## Users

#### Current user
Current user can be accessed any time by calling this method.
```objc
PNUser *user = [PNUser currentUser];
```
Several properties can also be accessed by calling the following methods on an user object.
```obj
[user username]
[user emailConfirmed]
[user expDate]
```

#### Register
Calling the flowwing method will request a registration from the server.
```objc
[PNUser registerUserWithUsername:@"something@domain.com"
                       andPassword:@"password"
                           response:^(PNUser *user, NSError *error) {
    }];
```
Inside the response call back, either user or error is nil. So you can check the registration result by looking at either of them.
Almost all the error message are human friendly. So you can just pop up the localized description of the error like this.
```objc
[error localizedDescription]
```
If the error is nil. the register process is completed. You can then do whatever you want in your app, probably segue to the next page.

#### Login


