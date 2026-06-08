QT += quick bluetooth core androidextras multimedia gui widgets
#QT += poppler-qt5

CONFIG += c++11z

INCLUDEPATH = ./dependencies/include
#INCLUDEPATH += /usr/include/poppler/qt5
#INCLUDEPATH += /usr/include

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        cpp/androidinterface.cpp \
        cpp/batteryinfo.cpp \
        cpp/debtools.cpp \
        cpp/main.cpp \
        cpp/sharefile.cpp \
        cpp/sock2bspp.cpp \
        cpp/socket.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

LIBS += -ldl
#LIBS += -L/usr/lib/x86_64-linux-gnu -lpoppler-qt5


QMAKE_LIBS += -Wl,-rpath,/usr/local/lib64/

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    cpp/androidinterface.h \
    cpp/batteryinfo.h \
    cpp/debtools.h \
    cpp/iSocket.h \
    cpp/main.private.h \
    cpp/sharefile.h \
    cpp/socket.h

DISTFILES += \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle.properties \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml \
    android/res/xml/filepaths.xml \
    android/src/org/ekkescorner/examples/sharex/QShareActivity.java \
    android/src/org/ekkescorner/utils/QSharePathResolver.java \
    android/src/org/ekkescorner/utils/QShareUtils.java

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

#ANDROID_EXTRA_LIBS = $$PWD/Sock2BSPP/candidate-1.6.0/build.armAndroid/libSock2BSPP.so
#ANDROID_EXTRA_LIBS = $$PWD/../Sock2BSPP/candidate-1.6.0/build.armAndroid/libSock2BSPP.so
ANDROID_EXTRA_LIBS = $$PWD/../Sock2BSPP/application/build.armAndroid/libSock2BSPP.so

android
{
my_files.path = /assets
my_files.files = $$PWD/data_assets
INSTALLS += my_files
}
