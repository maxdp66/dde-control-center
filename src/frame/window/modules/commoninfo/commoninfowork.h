/*
 * Copyright (C) 2011 ~ 2019 Deepin Technology Co., Ltd.
 *
 * Author:     wuchuanfei <wuchuanfei_cm@deepin.com>
 *
 * Maintainer: wuchuanfei <wuchuanfei_cm@deepin.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#pragma once
#include "window/namespace.h"

#include <com_deepin_daemon_systeminfo.h>
#include <com_deepin_daemon_grub2.h>
#include <com_deepin_daemon_grub2_theme.h>
#include <com_deepin_system_userexperience_daemon.h>

#include <QObject>

using GrubDbus = com::deepin::daemon::Grub2;
using GrubThemeDbus = com::deepin::daemon::grub2::Theme;
using UeProgramDbus = com::deepin::userexperience::Daemon;

namespace DCC_NAMESPACE {
namespace commoninfo {
class CommonInfoModel;

class CommonInfoWork : public QObject
{
    Q_OBJECT
public:
    explicit CommonInfoWork(CommonInfoModel *model, QObject *parent = nullptr);

    void activate();
    void deactivate();

    void loadGrubSettings();
    bool defaultUeProgram();

public Q_SLOTS:
    void setBootDelay(bool value);
    void setEnableTheme(bool value);
    void setDefaultEntry(const QString &entry);
    void grubServerFinished();
    void onBackgroundChanged();
    void setBackground(const QString &path);
    void setUeProgram(bool enabled);
private:
    void getEntryTitles();
    void getBackgroundFinished(QDBusPendingCallWatcher *w);

private:
    CommonInfoModel *m_commomModel;
    GrubDbus *m_dBusGrub;
    GrubThemeDbus *m_dBusGrubTheme;
    UeProgramDbus *m_dBusUeProgram; // for user experience program
};
} // namespace commoninfo
} // namespace DCC_NAMESPACE
