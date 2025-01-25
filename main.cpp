#include "roverTracker.hpp"
#include "roverangle.hpp"
#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[]) {
  QGuiApplication app(argc, argv);

  // add the RoverAngle type
  qmlRegisterType<RoverAngle>("SSRTelemetry", 1, 0, "RoverAngle");
  qmlRegisterType<RoverTracker>("com.example", 1, 0, "RoverTracker");

  QQmlApplicationEngine engine;
  QObject::connect(
      &engine, &QQmlApplicationEngine::objectCreationFailed, &app,
      []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);
  engine.loadFromModule("SSRTelemetry", "Main");

  return app.exec();
}
