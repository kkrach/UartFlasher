#include <QApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include <QQmlContext>
#include "ComPortModel.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;

    ComPortModel comPortModel;
    comPortModel.updateItems();
    QQmlContext *classContext = engine.rootContext();
    classContext->setContextProperty("comPortModel", &comPortModel);

    // QML must be loaded after the context properties are set, otherwise they
    // cannot be used in the QML
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    for( const QObject* rootObject : engine.rootObjects() )
    {
        QObject::connect(rootObject, SIGNAL(comPortModelUpdateRequested()),
                         &comPortModel, SLOT(updateItems()));
    }

    return app.exec();
}
