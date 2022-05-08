
<a href="https://github.com/Rescado/rescado-app/actions/workflows/quality-control.yml"><img alt="CI - check quality" align="right" src="https://github.com/Rescado/rescado-app/actions/workflows/quality-control.yml/badge.svg"></a>

# Rescado

Adopt, don't shop.

## Firebase setup

The Firebase API keys are not versioned,  so you will need to provide these as additional arguments when running/building. Each platform requires its key to be set, e.g. the iOS app runs fine without an `androidFirebaseKey` but it will crash if no `iosFirebaseKey` is provided.
```shell
flutter run \
  --dart-define=iosFirebaseKey=$FIREBASE_KEY_IOS \
  --dart-define=androidFirebaseKey=$FIREBASE_KEY_ANDROID
```

You can get these keys by logging into the Firebase Web Console and downloading the `google-services.json` and `GoogleService-Info.plist` for Android and iOS respectively, and look for the API key in there. Or, you can use the FlutterFire CLI to generate a temporary `firebase_options.dart` which will hold these keys as well.

```shell
# Install Firebase CLI
brew install firebase-cli
# Log in to Firebase
firebase login
# Install FlutterFire CLI
dart pub global activate flutterfire_cli
# Create `firebase_options.dart`
flutterfire configure
```
If asked for an iOS bundle ID, it's `org.rescado.ios`. 👍

## If iOS build fails

```shell
cd ios
pod cache clean --all
pod update
```
And cross your fingers.
