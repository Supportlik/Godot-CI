FROM ubuntu:jammy
LABEL author="michael@bortlik.io"

USER root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    git-lfs \
    unzip \
    wget \
    zip \
    adb \
    openjdk-17-jdk-headless \
    rsync \
    dotnet-sdk-8.0

# Android Debug Key Configuration
ENV GODOT_ANDROID_KEYSTORE_DEBUG_PATH="/root/debug.keystore"
ENV GODOT_ANDROID_KEYSTORE_DEBUG_USER="androiddebugkey"
ENV GODOT_ANDROID_KEYSTORE_DEBUG_PASSWORD="android"

# Environment Variable 
ENV EXPORT_NAME="my-game"
ENV EXPORT_VERSION="v0.0.1"
ENV EXPORT_EXTENSION=".exe"
ENV EXPORT_TEMPLATE="Windows Desktop"

# Export Path for workdir and buildfolder
ENV PROJECT_PATH="/godot"
ENV BUILD_PATH="/build"

ENV GODOT_VERSION="4.2.1"
ENV RELEASE_NAME="stable_mono"
ENV RELEASE_NAME_TEMPLATE="stable.mono"
ENV SUBDIR="/mono"
ENV GODOT_TEST_ARGS=""
ENV GODOT_PLATFORM="linux_x86_64"
ENV GODOT_PLATFORM_BINARY="linux.x86_64"

# Download Godot and export templates
RUN wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}${SUBDIR}/Godot_v${GODOT_VERSION}-${RELEASE_NAME}_${GODOT_PLATFORM}.zip \
    && wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}${SUBDIR}/Godot_v${GODOT_VERSION}-${RELEASE_NAME}_export_templates.tpz \
    && mkdir ~/.cache \
    && mkdir -p ~/.config/godot \
    && mkdir -p ~/.local/share/godot/export_templates/${GODOT_VERSION}.${RELEASE_NAME_TEMPLATE} \
    && unzip Godot_v${GODOT_VERSION}-${RELEASE_NAME}_${GODOT_PLATFORM}.zip \
    && mv Godot_v${GODOT_VERSION}-${RELEASE_NAME}_${GODOT_PLATFORM}/* /usr/local/bin \
    && mv /usr/local/bin/Godot_v${GODOT_VERSION}-${RELEASE_NAME}_${GODOT_PLATFORM_BINARY} /usr/local/bin/godot \
    && unzip Godot_v${GODOT_VERSION}-${RELEASE_NAME}_export_templates.tpz \
    && mv templates/* ~/.local/share/godot/export_templates/${GODOT_VERSION}.${RELEASE_NAME_TEMPLATE} \
    && rm -f Godot_v${GODOT_VERSION}-${RELEASE_NAME}_export_templates.tpz Godot_v${GODOT_VERSION}-${RELEASE_NAME}_${GODOT_PLATFORM}.zip



# Download and setup android-sdk
ENV ANDROID_HOME="/usr/lib/android-sdk"
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip \
    && unzip commandlinetools-linux-*_latest.zip -d cmdline-tools \
    && mv cmdline-tools $ANDROID_HOME/ \
    && rm -f commandlinetools-linux-*_latest.zip

# Extend Path with Android SDK Tools
ENV PATH="${ANDROID_HOME}/cmdline-tools/cmdline-tools/bin:${PATH}"

# Install Android SDK for Godot (33)
RUN yes | sdkmanager --licenses \
    && sdkmanager "platform-tools" "build-tools;33.0.2" "platforms;android-33" "cmdline-tools;latest" "cmake;3.22.1" "ndk;25.2.9519653"

# Adding android keystore and settings
RUN keytool -keyalg RSA -genkeypair -alias ${GODOT_ANDROID_KEYSTORE_DEBUG_USER} -keypass ${GODOT_ANDROID_KEYSTORE_DEBUG_PASSWORD} -keystore debug.keystore -storepass ${GODOT_ANDROID_KEYSTORE_DEBUG_PASSWORD} -dname "CN=Android Debug,O=Android,C=US" -validity 9999 \
    && mv debug.keystore ${GODOT_ANDROID_KEYSTORE_DEBUG_PATH}

# Create Project and Build Folders
RUN mkdir -v -p ${BUILD_PATH}
RUN mkdir -v -p ${PROJECT_PATH}

WORKDIR ${PROJECT_PATH}

CMD ["sh", "-c", "godot --headless --verbose --export-debug \"$EXPORT_TEMPLATE\" \"${BUILD_PATH}/${EXPORT_NAME}${EXPORT_VERSION}${EXPORT_EXTENSION}\""]