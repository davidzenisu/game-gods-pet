# game-gods-pet

Using:
https://github.com/Malcolm-Q/SteamGodotTemplate
https://derkork.github.io/godot-statecharts/usage
https://www.reddit.com/r/godot/comments/13ikz4u/comment/lvmqaw0/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button

Follow instructions here: 

https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html

export JAVA_HOME=/run/media/deck/07f3ad58-56f4-4b23-91ca-c184f0de2af2/Dev/dependencies/jdk-17.0.17+10/

./sdkmanager --sdk_root=/run/media/deck/07f3ad58-56f4-4b23-91ca-c184f0de2af2/Dev/dependencies/android-sdk "platform-tools" "build-tools;35.0.0" "platforms;android-35" "cmdline-tools;latest" "cmake;3.10.2.4988404" "ndk;28.1.13356709"


The following command requires that the Java SDK path is set in editor settings (not in code!!)


godot --headless --editor res://ci/ci_bootstrap.tscn
godot --headless --install-android-build-template --export-debug "Android" build/game.apk


https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html#environment-variables


Android export environment variables
Export option

Environment variable

Encryption / Encryption Key

GODOT_SCRIPT_ENCRYPTION_KEY

Options / Keystore / Debug: GODOT_ANDROID_KEYSTORE_DEBUG_PATH

Options / Keystore / Debug User: GODOT_ANDROID_KEYSTORE_DEBUG_USER

Options / Keystore / Debug Password: GODOT_ANDROID_KEYSTORE_DEBUG_PASSWORD

Options / Keystore / Release: GODOT_ANDROID_KEYSTORE_RELEASE_PATH

Options / Keystore / Release User: GODOT_ANDROID_KEYSTORE_RELEASE_USER

Options / Keystore / Release Password: GODOT_ANDROID_KEYSTORE_RELEASE_PASSWORD


To generate a certificate, the following command was used:

```
keytool -genkeypair \
  -alias upload \
  -keyalg RSA \
  -keysize 4096 \
  -validity 10000 \
  -keystore upload-keystore.jks \
  -dname "CN=David Zeni-Su, OU=ovid, O=ovid, L=Vienna, ST=Vienna, C=AT"
```
The manually generated password was generated via `openssl rand -base64 32`.
Then the following details were uploaded to GitHub Actions as secrets:

GODOT_ANDROID_KEYSTORE_BASE64 => `base64 upload-keystore.jks > keystore_base64.txt`
GODOT_ANDROID_KEYSTORE_RELEASE_USER => Name from the certificate (technically not a secret and not required, can be read from the public cert)
GODOT_ANDROID_KEYSTORE_RELEASE_PASSWORD => From the generated password (see above)

Long-term, this could be stored in a secret manager (to make it retrievable if Github is lost/broken)
