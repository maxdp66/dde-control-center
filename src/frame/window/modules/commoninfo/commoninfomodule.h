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

#include "window/interface/moduleinterface.h"

QT_BEGIN_NAMESPACE
#include <QObject>
QT_END_NAMESPACE

namespace DCC_NAMESPACE {
namespace commoninfo {
class CommonInfoModel;
class CommonInfoWork;
class CommonInfoWidget;
class BootWidget;
// 为开发者模式预留
//class DeveloperModeWidget;
class UserExperienceProgramWidget;
// 以下内容为平板模式做预留
//class TabletModeWidget;

class CommonInfoModule : public QObject, public ModuleInterface
{
    Q_OBJECT
public:
    explicit CommonInfoModule(FrameProxyInterface *frame, QObject *parent = nullptr);
    ~CommonInfoModule();
    //　初始化模块
    virtual void initialize() override;
    // 返回模块名
    virtual const QString name() const override;
    // 当模块第一次被点击时会被调用
    virtual void active() override;
    virtual void deactive() override;
    // 当搜索到相关字段后，load会被调用
    virtual void load(QString path) override;
public Q_SLOTS:
    void onShowBootWidget(); // for bootmenu
    void onShowDeveloperWidget(); // for developer mode
    void onShowUEPlanWidget(); // for user exprience program
    // 以下内容为平板模式做预留
    //void onShowTabletModeWidget(); // for tablet mode
private:
    void initBootWidget();
    void initUeProgramWidget(); // for user experience program
private:
    CommonInfoWork *m_commonWork;
    CommonInfoModel *m_commonModel;
    CommonInfoWidget *m_commonWidget; // main widget
    BootWidget *m_bootWidget; // for bootmenu
    UserExperienceProgramWidget *m_ueProgramWidget; // for user experience program
    // 为开发者模式预留
//    DeveloperModeWidget *m_developerWidget; // for developer mode
    // 以下内容为平板模式做预留
    //TabletModeWidget* mTabletModeWidget;
};

}// namespace commoninfo
}// namespace DCC_NAMESPACE
