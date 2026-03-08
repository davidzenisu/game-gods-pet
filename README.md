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

godot --headless --install-android-build-template --export-debug "Android" build/game.apk