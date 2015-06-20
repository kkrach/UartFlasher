TEMPLATE = app

QT += qml quick widgets serialport
CONFIG += c++11

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    src/StringListModel.h \
    src/ComPortModel.h \
    src/SerialConnection.h

SOURCES += src/main.cpp \
    src/StringListModel.cpp \
    src/ComPortModel.cpp \
    src/SerialConnection.cpp

RESOURCES += res/qml.qrc

# Additional import path used to resolve QML modules in Qt Creator s code model
QML_IMPORT_PATH = res/
