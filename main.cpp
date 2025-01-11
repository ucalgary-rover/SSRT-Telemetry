#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "roverangle.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // add the RoverAngle type
    qmlRegisterType<RoverAngle>("SSRTelemetry", 1, 0, "RoverAngle");

    QQmlApplicationEngine engine;
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
                     &app, []() { QCoreApplication::exit(-1); },
                     Qt::QueuedConnection);
    engine.loadFromModule("SSRTelemetry", "Main");

    return app.exec();
}