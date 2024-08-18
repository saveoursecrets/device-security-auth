# Device Security Authentication

Authenticate to an account using a password stored on a device and protected by the device's security which may be biometric, PIN, passcode or other enrolled device security.

On MacOS and iOS this uses the local keychain and the `kSecAttrAccessControl` attribute so that the user must confirm their presence using TouchID, FaceID or a PIN code when reading the password.

For other platforms this uses a combination of the [local_auth](https://pub.dev/packages/local_auth) package and the [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) package.

© Copyright Save Our Secrets Pte Ltd 2023; all rights reserved.
