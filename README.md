# ProjectNingIOS
SDK project and a sample app built over the SDK.

To use this SDK, please import PNService.h in your .h file to access all the methodes in the SDK.

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
[user accessToken]
```
This method can be used to check if there is currently a logged in user or not. It will return nil if there is, or a NSError with a friendly error message.
```obj
[PNUser checkUserLoginStatus]
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
Calling the flowwing method will request a registration from the server.
```objc
[PNUser loginUserWithUsername:@"something@domain.com"
                  andPassword:@"password"
                    response:^(PNUser *user, NSError *error) {
}];
```
The result checking are the same as register process.

#### Log out
Calling the following method will logout the current user.
```objc
[PNUser logoutCurrentUser];
```

## Images

#### Upload Image
The following method will upload an image without need of a title.
```objc
[PNImage uploadImage:UIImage
              inType:@"sampleImageType"
            response:^(NSError *error){
}];
```

The following method will upload an image with a user defined title.
```objc
[PNImage uploadImage:UIImage
              inType:@"sampleImageType"
           withTitle:@"sampleImageTitle"
            response:^(NSError *error){
}];
```
Note that these two image upload methods need a logged in user to upload. Also, the 'user defined' title is adjusted by the server for now.

#### Delete Image
The following method will delete an image on server by image id
```objc
[PNImage deleteImage:NSNumber
            response:^(NSError *error){
}];
```
