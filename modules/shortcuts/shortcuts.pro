TEMPLATE        = lib
CONFIG         += plugin c++11 link_pkgconfig
QT             += widgets dbus
INCLUDEPATH    += ../../frame/ ../../widgets ../../widgets/private
PKGCONFIG += dui
LIBS += -L../../widgets -lwidgets

TARGET          = $$qtLibraryTarget(shortcuts)
DESTDIR         = $$_PRO_FILE_PWD_/../

HEADERS += \
    mainwidget.h \
    shortcuts.h \
    shortcutwidget.h \
    tooltip.h \
    selectdialog.h

SOURCES += \
    mainwidget.cpp \
    shortcuts.cpp \
    shortcutwidget.cpp \
    tooltip.cpp \
    selectdialog.cpp

RESOURCES += \
    theme.qrc
