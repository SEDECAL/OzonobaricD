# OzonobaricD

Android tablet UI for the **OzonobaricD** medical ozone generator developed by [Sedecal S.A.](https://www.sedecal.com).

The application runs on an Android tablet and communicates with the device hardware over Bluetooth Low Energy. It allows clinical operators to configure and run ozone therapy protocols, monitor pressure and flow in real time, and perform device calibration.

Built with **Qt 5.15.2 / QML** targeting **arm64-v8a** Android devices.

---

## Build requirements

| Dependency | Version |
|---|---|
| Qt | 5.15.2 |
| Qt Creator | 4.15.2 |
| Android NDK | r21e (or compatible) |
| Android SDK | API 29 or later |
| Target ABI | arm64-v8a |

### Qt modules (20)

| Qt module | Source repo | Source mirror |
|---|---|---|
| Core | qtbase | https://github.com/SEDECAL/qt5-qtbase |
| Gui | qtbase | https://github.com/SEDECAL/qt5-qtbase |
| Widgets | qtbase | https://github.com/SEDECAL/qt5-qtbase |
| Network | qtbase | https://github.com/SEDECAL/qt5-qtbase |
| Sql | qtbase | https://github.com/SEDECAL/qt5-qtbase |
| Concurrent | qtbase | https://github.com/SEDECAL/qt5-qtbase |
| Qml | qtdeclarative | https://github.com/SEDECAL/qt5-qtdeclarative |
| QmlModels | qtdeclarative | https://github.com/SEDECAL/qt5-qtdeclarative |
| QmlWorkerScript | qtdeclarative | https://github.com/SEDECAL/qt5-qtdeclarative |
| Quick | qtdeclarative | https://github.com/SEDECAL/qt5-qtdeclarative |
| QuickControls2 | qtquickcontrols2 | https://github.com/SEDECAL/qt5-qtquickcontrols2 |
| QuickTemplates2 | qtquickcontrols2 | https://github.com/SEDECAL/qt5-qtquickcontrols2 |
| Bluetooth | qtconnectivity | https://github.com/SEDECAL/qt5-qtconnectivity |
| Multimedia | qtmultimedia | https://github.com/SEDECAL/qt5-qtmultimedia |
| MultimediaQuick | qtmultimedia | https://github.com/SEDECAL/qt5-qtmultimedia |
| AndroidExtras | qtandroidextras | https://github.com/SEDECAL/qt5-qtandroidextras |
| Positioning | qtlocation | https://github.com/SEDECAL/qt5-qtlocation |
| PositioningQuick | qtlocation | https://github.com/SEDECAL/qt5-qtlocation |
| Location | qtlocation | https://github.com/SEDECAL/qt5-qtlocation |
| RemoteObjects | qtremoteobjects | https://github.com/SEDECAL/qt5-qtremoteobjects |

---

## Build instructions

1. Install **Qt 5.15.2** with Android support from the Qt online installer. Make sure the `arm64-v8a` kit is available.
2. Install **Android NDK r21e** and **Android SDK API 29+** and configure their paths in Qt Creator (`Edit → Preferences → Devices → Android`).
3. Clone this repository:
   ```bash
   git clone https://github.com/SEDECAL/OzonobaricD.git
   cd OzonobaricD
   ```
4. Open `Ozd.pro` in Qt Creator.
5. Select the **Android arm64-v8a** kit.
6. Build → **Build Project** (or press `Ctrl+B`).
7. To deploy to a connected device: **Build → Deploy** or press `Ctrl+R`.

---

## Sock2BSPP — Bluetooth communication library

The Bluetooth communication stack is implemented in **Sock2BSPP**, a proprietary shared library developed by Sedecal S.A. It is included in this repository as a precompiled binary:

```
libs/arm64-v8a/libSock2BSPP.so
```

This binary was compiled with **Qt 5.15.2** for **arm64-v8a** (Android), linking dynamically against the following Qt modules:

| Qt module | Source mirror |
|---|---|
| Core | https://github.com/SEDECAL/qt5-qtbase |
| Gui | https://github.com/SEDECAL/qt5-qtbase |
| Network | https://github.com/SEDECAL/qt5-qtbase |
| Qml | https://github.com/SEDECAL/qt5-qtdeclarative |
| QmlModels | https://github.com/SEDECAL/qt5-qtdeclarative |
| Quick | https://github.com/SEDECAL/qt5-qtdeclarative |
| Bluetooth | https://github.com/SEDECAL/qt5-qtconnectivity |

In accordance with the Qt LGPLv3 license, the user may relink this library against a modified version of Qt. Because it is distributed as a dynamic shared library, this requirement is automatically satisfied.

The source code of Sock2BSPP is not available under an open-source license.

---

## License

The UI source code in this repository is licensed under the **GNU Lesser General Public License v3.0 or later**. See the [LICENSE](LICENSE) file for the full text.

Third-party components:

- **ekke's ShareUtils for Qt on Android** (`android/src/org/ekkescorner/`) — MIT License  
  Source: https://github.com/ekke/ekkesSHAREexample

- **QSharePathResolver** (`android/src/org/ekkescorner/utils/QSharePathResolver.java`) — MIT License  
  Based on: https://github.com/wkh237/react-native-fetch-blob

See [NOTICE](NOTICE) for full third-party attributions.

---

## Medical device notice

OzonobaricD is control software for a **medical device**. Clinical use requires the applicable regulatory certifications and authorisations in your jurisdiction. Sedecal S.A. makes no warranty as to the fitness of this software for any clinical purpose. Use in a medical context is solely the responsibility of the qualified operator and the relevant regulatory body.

---

## Contact

For technical questions contact Sedecal S.A.:  
https://www.sedecal.com
