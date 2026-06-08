// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

#include "debtools.h"
#include <QDebug>
#include <QQmlContext>
#include <QQmlApplicationEngine>

debTools::debTools()
{
}

QString debTools::idName(QObject * object) const
{
    const auto context = qmlContext(object);
    return context ? context->nameForObject(object): QString("context not found");
}
