# Build Environment Setup Guide — OzonobaricD

**Project:** OzonobaricD (Sedecal S.A.)
**Goal:** Build the project from https://github.com/SEDECAL/OzonobaricD and generate an Android APK (arm64-v8a).
**Recommended OS:** Ubuntu 22.04 LTS (64-bit)

---

## Table of Contents

1. [System Requirements](#1-system-requirements)
2. [Install System Dependencies](#2-install-system-dependencies)
3. [Install Java JDK 8 and JDK 17](#3-install-java-jdk-8-and-jdk-17)
4. [Install Android Studio and Configure the SDK](#4-install-android-studio-and-configure-the-sdk)
5. [Install NDK r21e](#5-install-ndk-r21e)
6. [Install Qt 5.15.2 with Android Support](#6-install-qt-5152-with-android-support)
7. [Configure Qt Creator for Android](#7-configure-qt-creator-for-android)
8. [Clone the Repository](#8-clone-the-repository)
9. [Prepare the Sock2BSPP Dependency](#9-prepare-the-sock2bspp-dependency)
10. [Open the Project in Qt Creator](#10-open-the-project-in-qt-creator)
11. [Select the Build Kit](#11-select-the-build-kit)
12. [Build the Project](#12-build-the-project)
13. [Install the APK on the Device (optional)](#13-install-the-apk-on-the-device-optional)
14. [Troubleshooting](#14-troubleshooting)

---

## 1. System Requirements

Before starting, verify the computer meets the following minimum requirements:

| Resource | Minimum | Recommended |
|---|---|---|
| Operating system | Ubuntu 20.04 LTS 64-bit | Ubuntu 22.04 LTS 64-bit |
| RAM | 8 GB | 16 GB |
| Free disk space | 20 GB | 30 GB |
| Internet connection | Required during installation | — |

> **Why so much space?** Qt with Android support takes ~5 GB, Android SDK + NDK ~7 GB, Android Studio ~1.5 GB, and the repository with dependencies ~500 MB.

---

## 2. Install System Dependencies

Open a terminal (`Ctrl + Alt + T`) and run the following commands one by one. Each command may ask for the user password (`sudo`).

```bash
sudo apt update
```
*(Updates the list of available packages. May take 1–2 minutes.)*

```bash
sudo apt install -y git curl wget unzip libgl1-mesa-dev
```
*(Installs git for cloning repositories and libraries required by Qt Creator.)*

Verify git was installed correctly:
```bash
git --version
```
Should display something like `git version 2.34.1` (exact number does not matter).

---

## 3. Install Java JDK 8 and JDK 17

Two Java versions are needed, each serving a different role:

| Version | Used for |
|---|---|
| **Java 8** | Building the project (Gradle) |
| **Java 17** | Android SDK tools (`sdkmanager`) and Qt Creator |

> The modern `sdkmanager` requires Java 17 or later. Without it, Qt Creator cannot verify the SDK or create Android build kits.

### 3.1 Install OpenJDK 8 and OpenJDK 17

```bash
sudo apt install -y openjdk-8-jdk openjdk-17-jdk
```

### 3.2 Verify the Installation

```bash
java -version
```
Should display:
```
openjdk version "1.8.0_xxx"
OpenJDK Runtime Environment (...)
```

### 3.3 If You Have Multiple Java Versions Installed

If another Java version is already installed, select Java 8 as the system default:

```bash
sudo update-alternatives --config java
```
A numbered menu appears. Type the number corresponding to `java-8-openjdk` and press Enter.

Repeat for the compiler:
```bash
sudo update-alternatives --config javac
```

### 3.4 Note the Java Paths

Typical paths on Ubuntu are:
- Java 8: `/usr/lib/jvm/java-8-openjdk-amd64`
- Java 17: `/usr/lib/jvm/java-17-openjdk-amd64`

Verify them with:
```bash
ls /usr/lib/jvm/
```

**Java 17** will be set as the Qt Creator JDK location in step 7 (required for `sdkmanager`).

---

## 4. Install Android Studio and Configure the SDK

Android Studio is Google's official Android development environment. It is used here primarily for its **SDK Manager**, which allows installing the exact SDK and NDK versions the project requires.

### 4.1 Download Android Studio

1. Open a browser and go to: https://developer.android.com/studio
2. Click **"Download Android Studio"**.
3. Accept the terms of service and download the `.tar.gz` file (approximately 1 GB).

### 4.2 Install Android Studio

Open a terminal and run the following commands. Replace `android-studio-XXXX.tar.gz` with the actual filename (you can check it with `ls ~/Downloads/`):

```bash
cd ~/Downloads
sudo tar -xzf android-studio-*.tar.gz -C /opt/
```
*(Extracts Android Studio into `/opt/android-studio/`. May take 2–3 minutes.)*

### 4.3 Run the First-Time Setup Wizard

```bash
/opt/android-studio/bin/studio.sh
```

The setup wizard appears:
1. Under "Install Type" choose **"Standard"** and click **"Next"**.
2. Accept all licenses (mark each as "Accept" and click "Finish").
3. Android Studio downloads the base SDK (~1 GB). Wait for it to finish.
4. Once installed, close Android Studio.

### 4.4 Locate the SDK Folder

The SDK is installed by default at: `~/Android/Sdk`

Verify it exists:
```bash
ls ~/Android/Sdk
```
Should display folders such as `build-tools`, `platforms`, `tools`.

Note this path: `~/Android/Sdk` (or the full path: `/home/YOUR_USERNAME/Android/Sdk`)

### 4.5 Install the Exact Versions Required by the Project

The project requires:
- **Android SDK Platform 29** (Android 10) — minimum SDK version declared in the manifest
- **Android SDK Platform 31** (Android 12) — compilation platform (`compileSdkVersion`)
- **Android SDK Build-Tools 28.0.3**
- **Android SDK Command-line Tools**

> **Why two platforms:** Platform 29 is the project's `minSdkVersion`; Platform 31 is the level it compiles against (`compileSdkVersion`). Both must be installed.

Install them from the Android Studio GUI:
1. Open Android Studio.
2. Menu **Tools → SDK Manager** (or **More Actions → SDK Manager** from the welcome screen).
3. Under the **"SDK Platforms"** tab: check **"Android 10.0 (Q)"** (API 29) **and** **"Android 12.0 (S)"** (API 31).
4. Under the **"SDK Tools"** tab:
   - Check **"Android SDK Build-Tools"** version **28.0.3** (enable "Show Package Details" to see individual versions).
   - Check **"Android SDK Command-line Tools (latest)"**.
5. Click **"Apply"** and then **"OK"**. Wait for the download.

> **Important:** Do not install additional platforms (android-33, android-34, android-36…).
> If Qt Creator detects a newer platform it may select it automatically and the build will fail.
> If you already have other platforms installed, see section 14
> ("Error: For input string: 36.1").

---

## 5. Install NDK r21e

The NDK (Native Development Kit) allows compiling C++ code for Android. The project requires version **r21e** (internal code: `21.4.7075529`).

### 5.1 Install NDK r21e from Android Studio

1. In Android Studio, go to **Tools → SDK Manager**.
2. Click the **"SDK Tools"** tab.
3. Check **"Show Package Details"** (bottom-right corner).
4. Expand **"NDK (Side by side)"**.
5. Find and check version **`21.4.7075529`**.
6. Click **"Apply"** and wait for the download (~1.2 GB).

### 5.2 Verify the Installation

```bash
ls ~/Android/Sdk/ndk/
```
Should show a folder named `21.4.7075529`.

```bash
ls ~/Android/Sdk/ndk/21.4.7075529/
```
Should show files such as `ndk-build`, `toolchains/`, `platforms/`.

Note the full NDK path: `~/Android/Sdk/ndk/21.4.7075529`

---

## 6. Install Qt 5.15.2 with Android Support

### 6.1 Download the Qt Installer

1. Open a browser and go to: https://www.qt.io/download-qt-installer
2. Click **"Download Qt Online Installer for Linux"**.
3. A file named `qt-unified-linux-x64-online.run` (~50 MB) is downloaded.

### 6.2 Make the Installer Executable

```bash
cd ~/Downloads
chmod +x qt-unified-linux-x64-online.run
```

### 6.3 Run the Installer

```bash
./qt-unified-linux-x64-online.run
```

### 6.4 Installer Wizard Steps

**Step 1 — Sign in:**
- The installer requires a Qt account. If you do not have one, click **"Sign up"** to create a free account.
- Enter email and password, click **"Next"**.

**Step 2 — "Welcome to Open Source Qt Setup":**
- Select **"Qt for open source development"** and click **"Next"**.

**Step 3 — "Installation Folder":**
- Leave the default path: `/home/YOUR_USERNAME/Qt`
- Click **"Next"**.

**Step 4 — "Installation Options":**
- Select **"Custom installation"** and click **"Next"**.

**Step 5 — "Customize"** (component selection):

By default the installer only shows recent Qt versions. To make Qt 5.15.2 appear:

1. Click the **"Show"** button (top of the component tree).
2. Check **"Archive"** in the dropdown. The tree reloads with older versions.

Then select the components:

3. Expand **"Qt for development"** → **"Qt"** → **"Qt 5.15.2"**
4. Check **"Android"**.

   > If you also want to build for desktop Linux, check **"Desktop gcc 64-bit"** as well, but it is not needed for APK compilation.

5. Make sure **Qt Creator** is checked (it normally is by default).

The list of what should be checked:
```
[✓] Qt for development
    [✓] Qt
        [✓] Qt 5.15.2
            [✓] Android
[✓] Qt Creator
```

Click **"Next"** when done.

**Step 6 — "License Agreement":**
- Select **"I have read and agree to the terms contained in the license agreements"**.
- Click **"Next"**.

**Step 7 — "Ready to Install":**
- Click **"Install"**.
- The installer downloads and installs the selected components (~5–7 GB). **This step can take between 20 and 60 minutes** depending on internet speed. Do not close the window.

**Step 8 — Completion:**
- When "Installation has finished" appears, click **"Finish"**.
- Qt Creator opens automatically (you can close it for now).

### 6.5 Verify the Installation

```bash
ls ~/Qt/5.15.2/
```
Should display at least the `android` folder (which contains the Qt binaries for Android).

### 6.6 Qt 5.15.2 Source Code (Sedecal Mirror)

The installer above downloads the **precompiled Qt binaries**. If you additionally need to inspect or modify the source code of the Qt modules used in the project (for example, to relink `libSock2BSPP.so` against a modified version of Qt, as permitted by the LGPL v3 license), the source code is available in the Sedecal mirror:

**Repository:** https://github.com/SEDECAL/qt5-5.15.2

```bash
git clone https://github.com/SEDECAL/qt5-5.15.2
```

The repository contains the source code of the 8 Qt modules distributed in the APK:

```
qt5-5.15.2/
├── qtbase/           → Core, Gui, Widgets, Network, Sql, Concurrent
├── qtdeclarative/    → Qml, QmlModels, QmlWorkerScript, Quick
├── qtquickcontrols2/ → QuickControls2, QuickTemplates2
├── qtconnectivity/   → Bluetooth
├── qtmultimedia/     → Multimedia, MultimediaQuick
├── qtandroidextras/  → AndroidExtras
├── qtlocation/       → Positioning, PositioningQuick, Location
└── qtremoteobjects/  → RemoteObjects
```

> **Cloning this repository is not required to build the project.** The Qt binaries are already installed at `~/Qt/5.15.2/android/`.

---

## 7. Configure Qt Creator for Android

Qt Creator needs to know where the Android SDK and NDK you installed are located.

### 7.1 Open Qt Creator

```bash
~/Qt/Tools/QtCreator/bin/qtcreator
```

Or find it in the application launcher (search "Qt Creator").

### 7.2 Open the Android Preferences

In the top menu bar: **Edit → Preferences** (some versions: **Tools → Options**).

In the preferences window, find and click **"SDKs"** in the left panel. Then click the **"Android"** tab.

### 7.3 Configure the Paths

Fill in the following fields:

| Field | Value |
|---|---|
| **JDK location** | `/usr/lib/jvm/java-17-openjdk-amd64` *(Java 17, required by sdkmanager)* |
| **Android SDK location** | `/home/YOUR_USERNAME/Android/Sdk` *(replace YOUR_USERNAME)* |
| **Android NDK list** | Click **"Add..."** and select `/home/YOUR_USERNAME/Android/Sdk/ndk/21.4.7075529` |

> **To find your username:** type `whoami` in the terminal.
>
> For example, if your username is `ingenieria`, the paths would be:
> - SDK: `/home/ingenieria/Android/Sdk`
> - NDK: `/home/ingenieria/Android/Sdk/ndk/21.4.7075529`

### 7.4 Verify Qt Creator Detects the Android Kit

After entering the paths, Qt Creator will show green checkmarks next to each field if everything is correct. If a warning or red error icon appears, verify the path is exact.

Click **"Apply"** and then **"OK"**.

---

## 8. Clone the Repository

### 8.1 Create a Working Folder

```bash
mkdir -p ~/OZD
cd ~/OZD
```

### 8.2 Clone the Repository

```bash
git clone https://github.com/SEDECAL/OzonobaricD.git
```

If the repository is private, Git will ask for a GitHub username and password. Enter the credentials of the GitHub account that has access to the repository.

### 8.3 Verify the Contents

```bash
ls ~/OZD/OzonobaricD/
```
Should display files such as `Ozd.pro`, `android/`, `cpp/`, `libs/`, `main.qml`, `qml.qrc`, etc. The `.qml` files are directly in the root of the repository, not in a subfolder.

---

## 9. Prepare the Sock2BSPP Dependency

The project depends on a proprietary Bluetooth communication library called **Sock2BSPP**. This library is distributed as a precompiled binary (`.so`) included in the repository at:

```
OzonobaricD/libs/arm64-v8a/libSock2BSPP.so
```

However, the project configuration file (`Ozd.pro`) expects to find that file at a relative path **outside** the repository:

```
../Sock2BSPP/application/build.armAndroid/libSock2BSPP.so
```

This means that, from the `~/OZD/OzonobaricD/` folder, the file must be at `~/OZD/Sock2BSPP/application/build.armAndroid/libSock2BSPP.so`.

### 9.1 Create the Expected Directory Structure

```bash
mkdir -p ~/OZD/Sock2BSPP/application/build.armAndroid
```

### 9.2 Copy the Precompiled .so

```bash
cp ~/OZD/OzonobaricD/libs/arm64-v8a/libSock2BSPP.so \
   ~/OZD/Sock2BSPP/application/build.armAndroid/libSock2BSPP.so
```

### 9.3 Verify

```bash
ls ~/OZD/Sock2BSPP/application/build.armAndroid/
```
Should display: `libSock2BSPP.so`

The folder structure should look like this:
```
~/OZD/
├── OzonobaricD/        ← cloned repository
│   ├── Ozd.pro
│   ├── android/
│   ├── cpp/
│   ├── libs/
│   │   └── arm64-v8a/
│   │       └── libSock2BSPP.so  ← original copy in repo
│   └── ...
└── Sock2BSPP/          ← created in this step
    └── application/
        └── build.armAndroid/
            └── libSock2BSPP.so  ← copy used by the compiler
```

---

## 10. Open the Project in Qt Creator

### 10.1 Open Qt Creator

If not already open:
```bash
~/Qt/Tools/QtCreator/bin/qtcreator
```

### 10.2 Open the Project File

1. In the menu bar: **File → Open File or Project...**
2. Navigate to `~/OZD/OzonobaricD/`
3. Select the file **`Ozd.pro`** and click **"Open"**.

### 10.3 Project Configuration Wizard

A **"Configure Project"** window appears showing the available kits. This window lists all build kits Qt Creator has detected.

---

## 11. Select the Build Kit

### 11.1 What to Look For

In the "Configure Project" window, look for a kit named something like:

```
Android Qt 5.15.2 Clang arm64-v8a
```

or

```
Android for arm64-v8a (Clang Qt 5.15.2)
```

Check **only** that kit (make sure all other kits are unchecked).

> **Note:** If no Android kit appears, the SDK/NDK configuration is incomplete. Go back to step 7 and verify the paths.

### 11.2 Confirm

Click **"Configure Project"**.

Qt Creator will load the project. The file tree appears in the left panel. This may take 30–60 seconds.

### 11.3 Verify and Fix the Android Build SDK to `android-31`

This step is **mandatory**. Qt Creator may have automatically selected an incorrect platform, which would cause a Gradle error during compilation.

1. In the left panel, click the **"Projects"** icon (wrench).
2. Select the kit **"Qt 5.15.2 for Android Multi-Abi"** → **"Build"** tab.
3. Expand the **"Build Android APK"** step → click **"Details"**.
4. Check the **"Android build SDK:"** field. It must show **`android-31`**.
   - If it shows any other value (android-33, android-36.1, etc.), change it to `android-31`.
5. Click **"Apply"**.

> If `android-31` does not appear in the dropdown, the platform is not installed.
> Go back to step 4.5 and install **Android SDK Platform 31**.

### 11.4 Switch to Release Mode (optional but recommended)

In the left bar of Qt Creator there is a build mode selector (usually showing a hammer icon). Click it and select **"Release"** instead of **"Debug"** to generate an optimized APK.

---

## 12. Build the Project

### 12.1 Build

In the menu bar: **Build → Build Project "Ozd"**

Or use the keyboard shortcut: **Ctrl + B**

### 12.2 Follow the Progress

At the bottom of Qt Creator there is a progress bar and a messages panel. You will see the build advance:

1. First qmake generates the makefiles (~5–10 seconds)
2. Then it compiles the C++ files (~1–3 minutes)
3. Then Gradle assembles the APK (~2–5 minutes; on the first run it downloads ~200 MB of dependencies)

**The full process can take between 5 and 15 minutes the first time.**

### 12.3 Success Messages

If everything goes well, you will see in the messages panel:

```
BUILD SUCCESSFUL in Xs
```

And in the Qt Creator status bar at the bottom:

```
Build finished: 0 errors
```

### 12.4 Locate the Generated APK

The APK is generated at:
```
~/OZD/OzonobaricD/android-build/build/outputs/apk/debug/android-build-debug.apk
```

or in Release mode:
```
~/OZD/OzonobaricD/android-build/build/outputs/apk/release/android-build-release-unsigned.apk
```

To confirm:
```bash
find ~/OZD/OzonobaricD -name "*.apk" 2>/dev/null
```

---

## 13. Install the APK on the Device (optional)

### 13.1 Prepare the Android Device

On the Android tablet or phone:
1. Go to **Settings → About phone/tablet**.
2. Tap **"Build number"** 7 times until the message "You are now a developer" appears.
3. Go back to **Settings → System → Developer options**.
4. Enable **"USB debugging"**.

### 13.2 Connect the Device

Connect the device to the computer with a USB cable. A dialog appears on the device asking whether you trust the computer. Accept.

### 13.3 Install the APK from Qt Creator

In Qt Creator:
1. In the menu bar: **Build → Deploy Project "Ozd"**
2. Or press **Ctrl + R** (Run), which deploys and then runs.

Qt Creator will detect the connected device, install the APK and launch it automatically.

### 13.4 Install the APK Manually (alternative)

If you prefer to install the APK without Qt Creator:
```bash
adb install ~/OZD/OzonobaricD/android-build/build/outputs/apk/debug/android-build-debug.apk
```

If `adb` is not in the PATH:
```bash
~/Android/Sdk/platform-tools/adb install ~/OZD/OzonobaricD/android-build/build/outputs/apk/debug/android-build-debug.apk
```

---

## 14. Troubleshooting

### Error: "Cannot find JDK"

**Symptom:** Qt Creator shows a red warning next to the JDK field.
**Cause:** The Java path is incorrect.
**Solution:**
```bash
readlink -f $(which java) | sed 's:/bin/java::'
```
Use that exact path in **Edit → Preferences → SDKs → Android → JDK location**.

---

### Error: "SDK not found" or "NDK not found"

**Symptom:** Qt Creator does not detect the SDK or NDK.
**Cause:** The `cmdline-tools` folder is not installed or the paths are incorrect.
**Solution:**
```bash
ls ~/Android/Sdk/ndk/21.4.7075529/   # must exist
ls ~/Android/Sdk/platforms/android-29/  # must exist
```
If either is missing, go back to step 4 or 5 and install it.

---

### Error: "libSock2BSPP.so: No such file or directory"

**Symptom:** Error during linking mentioning `libSock2BSPP.so`.
**Cause:** The `.so` file is not at the expected path.
**Solution:** Go back to step 9 and make sure the file exists at:
```bash
ls ~/OZD/Sock2BSPP/application/build.armAndroid/libSock2BSPP.so
```

---

### Error: "Gradle build failed: Could not resolve..."

**Symptom:** Gradle error saying it cannot download dependencies.
**Cause:** No internet connection during the first build.
**Solution:** Make sure you have an internet connection and build again. Gradle downloads ~200 MB of dependencies the first time.

---

### Error: "No kits found for Android"

**Symptom:** The "Configure Project" window shows no Android kit.
**Cause:** Qt Creator could not verify the SDK because `sdkmanager` requires Java 17 but an older JDK is configured.
**Solution:**
1. Install Java 17: `sudo apt install openjdk-17-jdk`
2. In Qt Creator, go to **Edit → Preferences → SDKs → Android**.
3. Set **JDK location** to `/usr/lib/jvm/java-17-openjdk-amd64`.
4. Click **Apply**. Qt Creator will verify the SDK and create the kit automatically.
5. Close the project: **File → Close Project**.
6. Reopen it: **File → Open File or Project → Ozd.pro**.

---

### Error: "Target API level too low" or "min SDK version"

**Symptom:** Error mentioning the API level does not meet Google Play requirements.
**Cause:** This only applies if publishing to Google Play. For internal use it is not a problem.
**Solution:** For internal testing and deployment, ignore this warning.

---

### Gradle Error: `For input string: "36.1"` — compileSdkVersion is not an integer

**Symptom:** Gradle fails with:
```
For input string: "36.1"
A problem occurred evaluating root project 'android-build' — build.gradle line 38:
compileSdkVersion androidCompileSdkVersion.toInteger()
```

**Cause:** Qt Creator has `BuildTargetSdk=android-36.1` stored in the project file
`.qtcreator/Ozd.pro.user`. This happens when `android-36.1` was installed at some point
and Qt Creator selected it automatically; when the platform is uninstalled, the value
remains frozen in the project file.

**Solution from Qt Creator** (correct approach):
1. Left panel → **"Projects"** icon (wrench)
2. Kit **"Qt 5.15.2 for Android Multi-Abi"** → **"Build"** tab
3. Expand **"Build Android APK"** → **"Details"**
4. **"Android build SDK:"** field → change `android-36.1` to **`android-31`**
5. Click **"Apply"**
6. **Build → Run qmake** and then **Build → Build Project "Ozd"**

**Why uninstalling `android-36.1` from the SDK is not enough:** `androiddeployqt` does not
auto-detect the platform from the filesystem when Qt Creator already has one explicitly
stored in `.qtcreator/Ozd.pro.user`.

---

### APK installs but app crashes on launch

**Symptom:** The application installs but closes immediately or throws an error.
**Likely cause:** The device is not arm64-v8a, or there is a Bluetooth permissions issue.
**Solution:**
- Verify the device is arm64 (most modern Android tablets are).
- On the device, grant Bluetooth and location permissions when the app requests them.

---

## Version and Path Summary

Quick reference:

| Component | Version | Installation Path |
|---|---|---|
| Java JDK | 8 (1.8.0) | `/usr/lib/jvm/java-8-openjdk-amd64` |
| Android SDK | API 29 + 31, Build-Tools 28.0.3 | `~/Android/Sdk` |
| Android NDK | r21e (21.4.7075529) | `~/Android/Sdk/ndk/21.4.7075529` |
| Qt | 5.15.2 Android arm64-v8a | `~/Qt/5.15.2/android` |
| Qt Creator | 4.15.x | `~/Qt/Tools/QtCreator` |
| Repository | — | `~/OZD/OzonobaricD` |
| Sock2BSPP .so | — | `~/OZD/Sock2BSPP/application/build.armAndroid/` |

---

*Guide generated for Sedecal S.A. — OzonobaricD Project — June 2026*
