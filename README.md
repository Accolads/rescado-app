
<a href="https://github.com/Rescado/rescado-app/actions/workflows/quality-control.yml"><img alt="CI - check quality" align="right" src="https://github.com/Rescado/rescado-app/actions/workflows/quality-control.yml/badge.svg"></a>

# Rescado

Adopt, don't shop.

## Firebase setup

`firebase_options.dart` is not included because it contains secrets, so you'll need to generate this file yourself.

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
