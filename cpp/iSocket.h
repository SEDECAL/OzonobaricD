// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

#pragma once

#include <QString>

class iSocketSubscriptor {
public:
    virtual void topicUpdate( QString & topicName, QString & payload ) = 0;
    virtual const char *whoAmI() = 0;
    virtual ~iSocketSubscriptor(){}
};

class iSocket {
public:
    virtual void sendData ( QString ) = 0;
    virtual void subscribe( QVector<QString>topics, iSocketSubscriptor* subscriber ) = 0;
};


