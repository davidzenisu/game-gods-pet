# Custom Dockerfile for game-gods-pet devcontainer
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    openjdk-17-jdk \
    ruby-full \
    git-lfs \
    && rm -rf /var/lib/apt/lists/*

# Install Android SDK
ENV ANDROID_HOME=/opt/android-sdk
RUN mkdir -p ${ANDROID_HOME} && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O /tmp/cmdline-tools.zip && \
    unzip /tmp/cmdline-tools.zip -d ${ANDROID_HOME} && \
    mv ${ANDROID_HOME}/cmdline-tools ${ANDROID_HOME}/latest && \
    mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    mv ${ANDROID_HOME}/latest ${ANDROID_HOME}/cmdline-tools/ && \
    rm /tmp/cmdline-tools.zip

# Set PATH for Android SDK
ENV PATH="${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${PATH}"

# Install Android packages
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "build-tools;35.0.1" "platforms;android-35" "cmdline-tools;latest" "cmake;3.10.2.4988404" "ndk;28.1.13356709"

# Install fastlane
RUN gem install bundler

# Set environment variables
ENV GODOT_VERSION=4.6
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV GODOT_JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Install Godot
RUN wget https://github.com/godotengine/godot-builds/releases/download/${GODOT_VERSION}-stable/Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip -q
RUN unzip Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip
RUN sudo mv Godot_v${GODOT_VERSION}-stable_linux.x86_64 /usr/local/bin/godot
RUN rm -f Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip

# Run in user context
USER vscode
RUN mkdir ~/.cache
RUN mkdir -p ~/.config/godot
RUN mkdir -p ~/.local/share/godot/export_templates/${GODOT_VERSION}.stable
RUN wget https://github.com/godotengine/godot-builds/releases/download/${GODOT_VERSION}-stable/Godot_v${GODOT_VERSION}-stable_export_templates.tpz -q
RUN unzip Godot_v${GODOT_VERSION}-stable_export_templates.tpz
RUN mv templates/* ~/.local/share/godot/export_templates/${GODOT_VERSION}.stable
RUN rm -f Godot_v${GODOT_VERSION}-stable_export_templates.tpz
RUN rm -rf templates
