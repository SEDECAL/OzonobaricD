// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

#pragma once

#include <QObject>

class sock2BSPP : public QObject
{
    Q_OBJECT
public:
    sock2BSPP(QObject *parent = nullptr);
    ~sock2BSPP();

    enum BSPPRole {
        Master,
        Slave
    };

    Q_ENUM(BSPPRole)
    Q_INVOKABLE bool load();
//    Q_INVOKABLE bool startBle();
    Q_INVOKABLE QString state();

private:

public slots:
    void setRole( enum BSPPRole role );
    void resync();

};
