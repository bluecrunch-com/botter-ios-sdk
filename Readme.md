
## Onboard, retain and support mobile users at scale
Engage customers with in‑app messages and support them with an integrated knowledge base and help desk.  

## The Botter Messenger
The [Botter Messenger](https://botter.ai/) enables you to use it like a Messenger in your app, have conversations with your customers, send rich outbound messages, and track events.
The Botter SDK is the home for the conversations your customers have with you, and the place where they can self-serve for support or to learn more about your product.botter.live-IOS
You can open Botter from a persistent button that sits over your app’s UI, From there, your customer can  start a conversation, replies in both directions happen in real time.


## Contents
- [Installation](#Installation)
- [Integration](#Integration)
- [Supported integration languages](#Supported-integration-languages)
- [Current supported bot languages](#Supported-bot-languages)
- [Customer support](#Customer-support)
- [Push Notifications (FCM)](#Push-Notifications-FCM)
- [Customizations](#Customizations)
- [On-premise extra customizations](#On-premise-extra-customizations)
- [Customization parameters table](#Customizations-guidance-table)
- [Licence](#Licence)



## Installation
Install Botter to see and talk to users of your IOS app, Botter for IOS supports from target 11 and above.

<li>Add the below line in <strong>podfile</strong></li>

```
pod Botter
```

## Integration

<p>First, you need <strong>import Botter</strong> in your App delegate.then, you'll need to get your Botter iOS API key.
  To find this, just contact our support team to get you one. Then, initialize Botter by calling the following in the <strong>didFinishLaunchingWithOptions</strong> method of your AppDelegate class</p>
  
```
Botter.show(APIKey: "your API key")
```
<p>for the launcher to be visible thourghout the entire app you will need to follow these steps:</p>

> 1. remove _Scene Manifest_ from info.plist file
> 2. comment scene configuration functions in App delegate 
> 3. add this line in App Delegate class :

 ```swift
 var  window: UIWindow?
 ```
 
 <p>you trigger open chat action on your custom button </p>

```swift
@IBAction func openChat(){
  
       Botter.openChatScreen(APIKey: "nKmovPCdWNZ")
   }
```

<p>Add Needed Permissions in your info.plist file</p>

```html
<key>NSCameraUsageDescription</key>
<string>This app requires to access your photo library to send image via chat</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app requires to access your photo library to send image via chat</string>
```

## Supported integration languages
<li> Swift. </li>

## Current supported bot languages
<li> English </li>
<li> Arabic </li>


## Customer support

👋 Contact us with any integration/issues at [Botter - Contact us page](https://botter.ai/contact/). If you bump into any problems or need more support, just start a conversation with our support team.


## Push Notifications (FCM)
Below, we’ll show you how to send push notifications to your customers, with Firebase Cloud Messaging (FCM) in Botter.

### Step :one:: Enable Google services for your app
If you already have a Firebase project with notifications enabled you can skip to the next step. Otherwise go to the [FCM Console page](https://console.firebase.google.com/u/0/) and create a new project following these steps:

Give the project a name and click <strong>‘Create Project’</strong>.

Once your project is set up, scroll down and select the <strong>‘Cloud Messaging’</strong> card.

In the center of the project overview page, click the iOS icon to launch the setup workflow.

Enter your app’s Bundle identifier and click <strong>‘Register App’</strong>.

 
### Step :two:: Setup Application With Firebase

Click the button <strong>"Download GoogleService-Info.plist"</strong> to download the config file. You’ll need to move that file into the root of your Xcode project.

Click <strong>"next"</strong> and then in your app podfile add <strong>"Firebase SDK"</strong> then install pods

To connect Firebase when your app starts up, add the initialization code below to your main AppDelegate class.

```swift
import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
      [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

```

Click the <strong>Next</strong> button and then skip the verification step.


### Step :three:: Add your Server key to Botter for iOS settings

Finally, click the settings icon on top left and select <strong>‘Project settings’</strong>, then <strong>‘Cloud Messaging tab’</strong> and copy your Server key.


Open your Botter app’s dashboard and select <strong>‘Settings -> Configure Notifications’</strong>. Then find the <strong>‘Server Key’</strong> field. Here you'll be able to paste and save your Server API key.


### Step :four:: Configure Notifications in Application

in app target <strong>"signing & capabilities"</strong> click <strong>"+capability"</strong> and select <strong>"Push Notifications"</strong>

in <strong>"apple developer"</strong> website in <strong>"certificates identifiers & profiles"</strong> section add notification certifications with types <strong>"APNs Development iOS"</strong> and <strong>"Apple Push Services"</strong> then generate p12 files and upload it to your firebase project <strong>"project settings"</strong> > <strong>"Cloud Messaging"</strong> 

in appDelegate use the code below to <strong>"register"</strong> for remote notifications after this line <strong>"FirebaseApp.configure()"</strong> 

```swift
 if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            print("Remote instance ID token: \(result.token)")
            Botter.setFCMToken(token: result.token)
            
          }
        }

```
add delegate methods to receive notifications and pass it to <strong>"Botter SDK"</strong> to handle

```swift
extension AppDelegate : UNUserNotificationCenterDelegate{
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(notification.request.content.userInfo)
        if Botter.isBotterMessage(userInfo: notification.request.content.userInfo){
            Botter.handleMessage(userInfo: notification.request.content.userInfo) { (completion) in
                completionHandler(completion)
            }
        }else{
            completionHandler([.alert , .badge , .sound ])
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Botter.isBotterMessage(userInfo: userInfo){
            Botter.handleMessage(userInfo: userInfo) { (completion) in
                
            }
        }
    }
  }

```

### Step :five:: Share FCM Token with Botter SDK

send fcm token whenever token is refreshed

```swift
extension AppDelegate : MessagingDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print(fcmToken)
        Botter.setFCMToken(token: fcmToken)
    }
    
}

```


## Customizations
if you want anytime at any screen hide the Botter chat icon, just write the below line inside <strong>viewWillAppear</strong> method : 

```swift
Botter.hideLauncherButton()
```

and you can show it anytime using the below line at <strong>viewWillAppear</strong> also :

```swift
Botter.showLauncherButton()
```

You can also change bottom margin of the launcher button using : 

```swift
BotterSettingsManager.bottomMargin  = 40
```

If you have your custom button , and want to show chat screen directly then you can use the below line:

```swift
Botter.openChatScreen(APIKey: "Your Api key")
```

You can customize Botter with your preferred settings, when you initialize Botter instance inside <strong>didFinishLaunchingWithOptions</strong> method of your AppDelegate class like below : 

```swift
BotterSettingsManager.AccentColor = UIColor.init(codeString: "#72962C")
BotterSettingsManager.FontColor = UIColor.white
BotterSettingsManager.BotterMessageFontColor = UIColor.black
BotterSettingsManager.BotterMessageBGColor  = UIColor.init(codeString: "")
BotterSettingsManager.ChatTitleColor = UIColor.white
BotterSettingsManager.ChatTitleText  = "Botter"
BotterSettingsManager.HeadlineMessage  = "Chat with BOTTER"
BotterSettingsManager.WelcomeMessage  = "We’re here to answer your questions.\nAsk us anything!"
BotterSettingsManager.alignLauncherLeft = false
BotterSettingsManager.bottomMargin  = 40
BotterSettingsManager.Font.regularFontName = "Roboto-Regular"
BotterSettingsManager.Font.mediumFontName = "Roboto-Medium"
BotterSettingsManager.Font.boldFontName = "Roboto-Bold"
BotterSettingsManager.hasFAQs = false
BotterSettingsManager.logo = UIImage()
BotterSettingsManager.language  = .english
```

## On-premise extra customizations
for on-premise servers you can easily set (socket, API and upload) URLs calling these methods:

```swift
BotterSettingsManager.setBotSocket(url: "wss://...")
BotterSettingsManager.setBotBase(url: "https://...")
BotterSettingsManager.setBotUpload(url: "https://...")
```

## Customization parameters table:
| Name  | Description | Screenshot |
| ------------- | ------------- | ------------- |
| BotterSettingsManager.alignLauncherLeft | To set the launcher to the true/false | 
| BotterSettingsManager.language | To set the default bot language either .english/.arabic. | 
| setLauncherIcon | To change the launcher icon. | <img src="https://raw.githubusercontent.com/botter-live/botter.live-Android/master/.github/images/1.jpg" alt="1">|
| BotterSettingsManager.logo | To set the chat main logo. | <img src="https://raw.githubusercontent.com/botter-live/botter.live-Android/master/.github/images/2.jpg" alt="2">|
| BotterSettingsManager.AccentColor | This is the main color used all over the chat like launcher bg color, welcome screen top area bg color, chat header, ect… I.e. in the image accent color is purple. | <img src="https://raw.githubusercontent.com/botter-live/botter.live-Android/master/.github/images/main_color.jpg" alt="main_color">|
| BotterSettingsManager.HeadlineMessage ,  BotterSettingsManager.ChatTitleColor | Used to set the welcome screen header title text and color. | <img src="https://raw.githubusercontent.com/botter-live/botter.live-Android/master/.github/images/4.jpg" alt="4">|
| BotterSettingsManager.WelcomeMessage | Used to set the welcome screen header subtitle text. | <img src="https://raw.githubusercontent.com/botter-live/botter.live-Android/master/.github/images/3.jpg" alt="3">|
|BotterSettingsManager.ChatTitleText , BotterSettingsManager.ChatTitleColor | Used to set the main chat header title text and color | <img src="https://raw.githubusercontent.com/botter-live/botter.live-Android/master/.github/images/6.jpg" alt="6">|
| BotterSettingsManager.BotterMessageBGColor , BotterSettingsManager.BotterMessageFontColor | Used to set the botter message bubble bg color and it’s text color. | <img src="https://raw.githubusercontent.com/botter-live/botter.live-Android/master/.github/images/7.jpg" alt="7">
| BotterSettingsManager.Font.regularFontName | Used to set the primary font all over the chat. |
| BotterSettingsManager.Font.boldFontName | Used to set the secondary font all over the chat. |


# Licence 
Licensed under the Apache License, Version 2.0 (the "License"); you may not use this work except in compliance with the License. You may obtain a copy of at:
<a href='https://opensource.org/licenses/apache2.0.php'>https://opensource.org/licenses/apache2.0.php</a>


### Thank you 
