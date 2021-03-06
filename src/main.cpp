#include <QApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include <QQmlContext>
#include "ComPortModel.h"
#include "SerialConnection.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QQmlContext *classContext = engine.rootContext();

    ComPortModel comPortModel;
    comPortModel.updateItems();
    classContext->setContextProperty("comPortModel", &comPortModel);

    SerialConnection serialConnection;
    classContext->setContextProperty("serialConnection", &serialConnection);

    // QML must be loaded after the context properties are set, otherwise they
    // cannot be used in the QML
    engine.load(QUrl(QStringLiteral("qrc:///UartFlasherWindow.qml")));

    for( const QObject* rootObject : engine.rootObjects() )
    {
        QObject::connect(rootObject, SIGNAL(comPortModelUpdateRequested()),
                         &comPortModel, SLOT(updateItems()));
        QObject::connect(rootObject, SIGNAL(connectRequested(QString,QString,QString,int,QString,QString,QString,QString)),
                         &serialConnection, SLOT(setupConnection(QString,QString,QString,int,QString,QString,QString,QString)));
        QObject::connect(rootObject, SIGNAL(disconnectRequested()),
                         &serialConnection, SLOT(disconnect()));
        QObject::connect(rootObject, SIGNAL(sendRequested(QString)),
                         &serialConnection, SLOT(sendText(QString)));
    }

    return app.exec();
}
