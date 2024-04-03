# FastPay Flutter SDK

## FastPay Developers Arena

Accept payments with FastPay's APIs. Our simple and easy-to-integrate APIs allow for less effort in processing payments. This is an official support channel, but our APIs support both Android and iOS.

### Screenshots

| ![Screenshot 1](https://github.com/FastPaySDK/FastPayFlutterLibrary/blob/devZarraf/1.jpg?raw=true) | ![Screenshot 2](https://github.com/FastPaySDK/FastPayFlutterLibrary/blob/devZarraf/2.jpg?raw=true) | ![Screenshot 3](https://github.com/FastPaySDK/FastPayFlutterLibrary/blob/devZarraf/3.jpg?raw=true) |
| :---: | :---: | :---: |

## Quick Glance

- This plugin is official. [FastPay Developers Portal](https://developer.fast-pay.iq/).
- You need to contact FastPay to get a storeID and Password.

## Installation

```yaml
dependencies:
  fastpay_merchant: ^1.0.10
  #To handle callbacks (Redirection) from fastpay wallet application.
  app_links: ^4.0.0 
```


## Android Setup
  - Requires AndroidX

### Build Gradle

 Include support in ```android/app/build.gradle```
add this line if not exit:
```properties
implementation 'com.android.support:appcompat-v7:28.0.0'
```
### styles
 change theme app in ```android/app/src/main/res/values/styles.xml``` and ```android/app/src/main/res/values-night/styles.xml``` to :
##### if you want show appbar with app name title :
```bash 
Theme.AppCompat.Light
```
##### if you do not want show appbar with app name title :
```bash 
Theme.AppCompat.Light.NoActionBar
```
Example :
```properties
<!-- change theme app to AppCompat theme -->
 <style name="LaunchTheme" parent="Theme.AppCompat.Light">
       <!-- update this line to change background payment color to white -->
        <item name="android:windowBackground">#ffffff</item>
       ...

    </style>
```
### Manifest
add this line to  manifest
```properties
<application
       <-- lable name show in fastpay title screen -->
        android:label="example"
       <-- add this line in hear --> 
        android:theme="@style/LaunchTheme"
      ...
>
```

## IOS
It doesn't need to be changed
- iOS only supports real device you can't test it on simulator because FastPay SDK not support simulator

___

### Initiate FastPaySDK

- __Store ID__ : Merchant’s Store Id to initiate transaction
- __Store Password__ : Merchant’s Store password to initiate transaction
- __Order ID__ : Order ID/Bill number for the transaction, this value should be unique in every transaction
- __Amount__ : Payable amount in the transaction ex: “1000”
- __isProduction__ : Payment Environment to initiate transaction (false for test & true for real life transaction)
- __Call back Uri__: When the SDK redirect to the fastpay application for payment and after payment cancel or failed it throws a callback with this uri. It is used for deeplinking with the client app for catching callbacks from fastpay application.
- **Callback( Sdk status, message):** There are four sdk status (e.g. *FastpayRequest.SDKStatus.INIT*) and status message.

```dart 
  enum SDKStatus{
      INIT,
      PAYMENT_WITH_FASTPAY_APP,
      PAYMENT_WITH_FASTPAY_SDK,
      CANCEL
   }
```

## Examples 
```dart 
FastpayResult _fastpayResult = await FastPayRequest(
                    storeID: "********", 
                    storePassword: "********",
                    amount: "1000", 
                    orderID: "HBBS7657", 
                     isProduction: false,
              callback: (status,message){
                  debugPrint("CALLBACK..................."+message);
                  _showToast(context,message);
            },callbackUri: "sdk://your.website.com/further/paths",);

 if (_fastpayResult.isSuccess ?? false) {
       // transaction success
     } else {
       // transaction failed
     }
```

## SDK callback Uri

```dart
//Using app_links
import 'package:app_links/app_links.dart';

Future<void> _handleIncomingIntent() async {
    final _appLinks = AppLinks();
    final uri = await _appLinks.getLatestAppLink();
    final allQueryParams = uri?.queryParameters;
    final status = allQueryParams?['status'];
    final orderId = allQueryParams?['order_id'];
    debugPrint("..........................STATUS::: "+status.toString()+", OrderId:::"+orderId.toString());
  }
```

NOTE: Don't forget to add following code block to your android manifest file.

```properties
<application
    <activity
        android:name=".MainActivity"...>
        ...
        <intent-filter>
            <action android:name="android.intent.action.MAIN"/>
            <category android:name="android.intent.category.LAUNCHER"/>
        </intent-filter>
        <intent-filter>
            <data android:scheme="sdk" android:host="your.website.com" android:pathPrefix="/further/paths"/>
            <action android:name="android.intent.action.VIEW" />
            <category android:name="android.intent.category.DEFAULT" />
            <category android:name="android.intent.category.BROWSABLE" />
        </intent-filter>
        ...
    </activity>
      ...
</application>
```

For iOS redirection:

- Create URI Create a URI with a unique name (our suggestion is to provide your app name with prefix text "appfpclient", for example, if your app name is "FaceLook", your URI should be appfpclientFaceLook)
- Add URI to your `info.plist` Now add this URI to your app info.plist file
```yaml
  <key>CFBundleURLTypes</key>
  <array>
    <dict>
      <key>CFBundleURLSchemes</key>
      <array>
    < string>appfpclientFaceLook</string>
      </array>
    </dict>
  </array>
```

When __FastPayRequest__ call open FastPay SDK then after payment return __FastpayResult__ that contains:

### payment result 
- __isSuccess__ : return true for a successful transaction else false.
- __errorMessage__ : if transaction failed return failed result 
- __transactionStatus__ : Payment status weather it is success / failed.
- __transactionId__ : If payment is successful then a transaction id will be available.
- __orderId__ : Unique Order ID/Bill number for the transaction which was passed at initiation time.
- __paymentAmount__ : Payment amount for the transaction. “1000”
- __paymentCurrency__ : Payment currency for the transaction. (IQD)
- __payeeName__ : Payee name for a successful transaction.
- __payeeMobileNumber__ :  Number: Payee name for a successful transaction.
- __paymentTime__ : Payment occurrence time as the timestamp.
   
### Callback Uri via app deeplinks results.

```java
callback URI pattern (SUCCESS): sdk://your.website.com/further/paths?status=success&transaction_id=XXXX&order_id=XXXX&amount=XXX&currency=XXX&mobile_number=XXXXXX&time=XXXX&name=XXXX
callback URI pattern (FAILED): sdk://your.website.com/further/paths?status=failed&order_id=XXXXX
```


