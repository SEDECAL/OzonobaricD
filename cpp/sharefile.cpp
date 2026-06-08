// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

#include "sharefile.h"
#include <QDebug>
#include <QtAndroidExtras/QAndroidJniObject>
#include <QtQml>

#define SHARE_PATH "/sedecal_share_files"
#define PUBLIC_PATH "///storage/emulated/0/Download"

ShareFile::ShareFile(){
    copyAssetsToAPPData({"*.pdf", "*.html", "*.mp4", "*.png", "*.gif"});
}

void ShareFile::viewPdfFile(const QString &filePath){
    viewFile(filePath, "View File", "application/pdf", 0);
}
void ShareFile::viewHtmlFile(const QString &filePath){
    viewFile(filePath, "View File", "text/html", 0);
}
void ShareFile::viewMp4File(const QString &filePath){
    viewFile(filePath, "View File", "video/mp4", 0);
}
void ShareFile::viewPngFile(const QString &filePath){
    viewFile(filePath, "View File", "image/*", 0);
}

void ShareFile::viewFile(const QString &filePath, const QString &title, const QString &mimeType, const int &requestId)
{
    QAndroidJniObject jsPath = QAndroidJniObject::fromString(filePath);
    QAndroidJniObject jsTitle = QAndroidJniObject::fromString(title);
    QAndroidJniObject jsMimeType = QAndroidJniObject::fromString(mimeType);
    jboolean ok = QAndroidJniObject::callStaticMethod<jboolean>("org/ekkescorner/utils/QShareUtils",
                                                                "viewFile",
                                                                "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)Z",
                                                                jsPath.object<jstring>(), jsTitle.object<jstring>(), jsMimeType.object<jstring>(), requestId);
//                                                              jsPath.object<jstring>(), jsTitle.object<jstring>(), jsMimeType.object<jstring>(), prb);
//    qDebug() << "prb value: ?:" << prb;
//    prb++;

    if(!ok) {
        qWarning() << "Unable to resolve activity from Java";
    }
}

bool ShareFile::copyRecursively(const QString &srcFilePath, const QString &tgtFilePath,const QStringList &filters)
{
    QFileInfo srcFileInfo(srcFilePath);
    QFileInfo tgtFileInfo(tgtFilePath);
    if (srcFileInfo.isDir() && tgtFileInfo.isDir()) {
        QDir targetDir(tgtFilePath);
        QDir sourceDir(srcFilePath);
        sourceDir.setNameFilters(filters);
        QStringList fileNames = sourceDir.entryList(QDir::Files | QDir::NoDotAndDotDot); // | QDir::Dirs | QDir::Hidden | QDir::System);
        foreach (const QString &fileName, fileNames) {
            const QString newSrcFilePath = srcFilePath + QLatin1Char('/') + fileName;
            const QString newTgtFilePath = tgtFilePath + QLatin1Char('/') + fileName;

            qDebug() << __FUNCTION__ << "Copying " << newSrcFilePath << "to" << newTgtFilePath;

            QFile file(newSrcFilePath);
            file.copy(newTgtFilePath);
        }
    } else {
        qDebug() << __FUNCTION__ << ": Wrong paths...";
        return false;
    }
    return true;
}
void ShareFile::copyAssetsToAPPData(const QStringList &filters) {
    // to provide files to other apps we're using a specific folder
    // version 1 of this example used QStandardPaths::DocumentsLocation on Android and iOS
    // iOS: QStandardPaths::DocumentsLocation points to: <APPROOT>/Documents - so it's inside the sandbox
    // Android: QStandardPaths::DocumentsLocation points to: <USER>/Documents outside the app sandbox
    // this worked while using FileUrl (SDK 23)
    // Android > SDK 23 needs a FileProvider providing a contentUrl
    // FileProvider uses Paths (see android/res/xml/filepaths.xml) stored at QStandardPaths::AppDataLocation

    // now create the working dir if not exists
    QString docLocationRoot = QStandardPaths::standardLocations(QStandardPaths::AppDataLocation).value(0);
    qDebug() << __FUNCTION__ << ": QStandardPaths::AppDataLocation: " << docLocationRoot;
    QString mDocumentsWorkPath = docLocationRoot.append(SHARE_PATH);

    if (!QDir(mDocumentsWorkPath).exists()) {
        if (QDir("").mkpath(mDocumentsWorkPath)) {
            qDebug() << __FUNCTION__ << ": Documents location work directory created: " << mDocumentsWorkPath;
//          bool copied = copyRecursively(":/data_assets", mDocumentsWorkPath, filters);         // including data_assets directory on project (inthe same way than Images directory)
//          bool copied = copyRecursively(PUBLIC_PATH, mDocumentsWorkPath, filters);             // having information previoulsy loaded on PUBLIC_PATH by external method

            bool copied = copyRecursively("assets:/data_assets", mDocumentsWorkPath, filters);   // see explanation bellow
//          Including 'data_asset' directory (at the same level than '.pro' file in directory tree) into 'assets' directory of '.apk' file
//          After compilation information resuls on /build.armAndroid/android-build/assets/data_assets
//          Next structure should be included in the '.pro' file
//          android
//          {
//            my_files.path = /assets
//            my_files.files = $$PWD/data_assets
//            INSTALLS += my_files
//          }

            if(copied) {
                qDebug() << __FUNCTION__ << ": Assets files copied to documents location work directory. ";
            }
        } else {
            qDebug() << __FUNCTION__ << ": Failed to creating documents location work directory: " << mDocumentsWorkPath;
        }
    } else {
        qDebug() << __FUNCTION__ << ": Documents location work directory already exits: " << mDocumentsWorkPath;
    }
}

