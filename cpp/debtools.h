// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

#ifndef DEBTOOLS_H
#define DEBTOOLS_H

#include <QObject>

class debTools : public QObject
{
    Q_OBJECT
public:
    debTools();
    Q_INVOKABLE QString idName(QObject * object) const;
};

#endif // DEBTOOLS_H
