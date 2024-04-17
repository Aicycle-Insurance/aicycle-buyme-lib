
An Aicycle BuyMe package for Aicycle Insurance's partners.

### Usage

>
>1. Add the following to your "gradle.properties" file:
>
>```
>android.useAndroidX=true
>android.enableJetifier=true
>```
>2. Make sure you set the `compileSdkVersion` in your "android/app/build.gradle" file to 33:
>
>```
>android {
>  compileSdkVersion 33
>
>  ...
>}
>```
>3. Make sure you replace all the `android.` dependencies to their AndroidX counterparts (a full list can be found [Android migration guide](https://developer.android.com/jetpack/androidx/migrate)).

### Set permissions
   - **iOS** add these on ```ios/Runner/Info.plist``` file

```xml
<key>NSCameraUsageDescription</key>
<string>Your own description</string>

<key>NSMicrophoneUsageDescription</key>
<string>Your own description</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Your own description</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>Your own description</string>

<key>NSPhotoLibraryAddUsageDescription</key>
<string>Your own description</string>
```

  - **Android**
    - You need to ask for storage permission to save an image to the gallery. You can handle the storage permission using flutter_permission_handler. In Android version 10, Open the manifest file and add this line to your application tag
    <br />
    ```xml
    <application android:requestLegacyExternalStorage="true" .....>
    ```
    
    - Set permissions before ```<application>```
    <br />

    ```xml
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.ACCESS_MEDIA_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    ```

    - Change the minimum SDK version to 21 (or higher) in ```android/app/build.gradle```
    <br />

    ```
    minSdkVersion 22
    ```
### Import the package
```dart
import 'package:aicycle_buyme_lib/aicycle_buyme_lib.dart';
```

### Required
```dart
Future<void> main() async {
  /// add this two lines below
  WidgetsFlutterBinding.ensureInitialized();
  await AICycle.initial();

  runApp(const CameraApp());
}
```