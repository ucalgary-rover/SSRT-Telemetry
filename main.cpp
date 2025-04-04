#include "roverTracker.hpp"
#include "roverangle.hpp"
#include "sciencesensors.hpp"
#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[]) {
  QGuiApplication app(argc, argv);

  // add the RoverAngle type
  qmlRegisterType<RoverAngle>("SSRTelemetry", 1, 0, "RoverAngle");
  qmlRegisterType<RoverTracker>("SSRTelemetry", 1, 0, "RoverTracker");
  qmlRegisterType<ScienceSensors>("SSRTelemetry", 1, 0, "ScienceSensors");

  QQmlApplicationEngine engine;
  QObject::connect(
      &engine, &QQmlApplicationEngine::objectCreationFailed, &app,
      []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);
  engine.loadFromModule("SSRTelemetry", "Main");

  return app.exec();
}
