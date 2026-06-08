// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

#ifndef SHAREFILE_H
#define SHAREFILE_H

#include <QObject>

class ShareFile : public QObject
{
        Q_OBJECT
public:
    ShareFile();

    Q_INVOKABLE void viewPdfFile(const QString &filePath);
    Q_INVOKABLE void viewHtmlFile(const QString &filePath);
    Q_INVOKABLE void viewMp4File(const QString &filePath);
    Q_INVOKABLE void viewPngFile(const QString &filePath);
    void viewFile(const QString &filePath, const QString &title, const QString &mimeType, const int &requestId);
    bool copyRecursively(const QString &srcFilePath, const QString &tgtFilePath,const QStringList &filters);
    void copyAssetsToAPPData(const QStringList &filters);

//    int prb = 0;
};

#endif // SHAREFILE_H
