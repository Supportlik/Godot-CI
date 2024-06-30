# Links:

- GitHub: https://github.com/Supportlik/Godot-CI
- DockerHub: https://hub.docker.com/r/supportlik/godot-ci

# Tags:

- Godot-v4.2.1-mono: `latest`

# Godot CI with C# Mono Support

This repository provides a continuous integration (CI) setup for Godot projects using C# with Mono support. It is based
on [abarichello/godot-ci](https://github.com/abarichello/godot-ci) but has been improved to address issues with the
original Mono image and tailored to support diverse CI needs for automatic building.

## Features

- **Pre-configured Environment**: Set up for Godot 4.2.1-mono on Ubuntu Jammy.
  - **Export Templates**: Installed export templates for multiple platforms.
  - **Documented Environment Variables**: Clearly documented for ease of use.
  - **Android SDK**: Includes Android SDK version 33.
  - **Multi-Platform Export**: Ready to export for Windows, Linux, and Android.
  - **Pre-configured Android Debug Keys**: Android debug keys are already created for debug builds.

## Prerequisites

- **Docker**: Ensure you have Docker installed.

## Setup Instructions for altering the Image

1. **Clone the Repository**:
    ```sh
    git clone https://github.com/supportlik/godot-ci.git
    cd godot-ci
    ```

   2. **Build the Docker Image**:
      Build the Docker image which includes Godot, Mono, and the necessary export templates.
       ```sh
       docker build -t supportlik/godot-ci .
       ```

   3. **Environment Variables**:
      The Dockerfile and CI scripts come with the following environment variables for customization:

      **Note:** The Android debug keys are pre-configured and can be used directly for debug builds.

      ### Android Debug Key Configuration
       ```sh
       ENV GODOT_ANDROID_KEYSTORE_DEBUG_PATH="/root/debug.keystore" # Destination of the debug keystore
       ENV GODOT_ANDROID_KEYSTORE_DEBUG_USER="androiddebugkey" # keystore user
       ENV GODOT_ANDROID_KEYSTORE_DEBUG_PASSWORD="android" # keystore password
       ```

      ### Export Configuration
       ```sh
       ENV EXPORT_NAME="my-game"                # Name of the exported game
       ENV EXPORT_VERSION="v0.0.1"              # Version of the exported game
       ENV EXPORT_EXTENSION=".exe"              # File extension for the export
       ENV EXPORT_TEMPLATE="Windows Desktop"    # Export template to use
       ```

      ### Export Paths
       ```sh
       ENV PROJECT_PATH="/godot"                # Path where your Godot project is located in the container
       ENV BUILD_PATH="/build"                  # Path where the exported builds will be saved in the container
       ```

   4. **Set Up Export Templates in Godot**:
      Ensure you have configured export templates in your Godot project. These templates can be addressed with the
      corresponding `EXPORT_TEMPLATE` environment variable when running the container.

## Example Run without selfbuilding provided through Docker Hub

To run the Docker container and perform an export, you can use the following example command. This command exports a
project for Android and places the output in the `./build/android` directory.

```sh
docker run -it --rm \
  -v ./godot:/godot \
  -v ./build/android:/build \
  -e EXPORT_TEMPLATE="Android" \
  -e EXPORT_EXTENSION=".apk" \
  -e EXPORT_NAME="my-awesome-game" \
  -e EXPORT_VERSION="v01.03.04" \
  supportlik/godot-ci
```

This results in an APK file built into the ./build/android folder with the name my-awesome-gamev01.03.04.apk.

# Usage

Directory Structure:

godot: Directory where your Godot project files are located.
build: Directory where the exported builds will be saved.
Custom Commands:
The image can be used with altered commands to use Godot to your liking. For example, you can run the container and pass
custom Godot commands to perform various tasks within your CI pipeline.

Happy coding!