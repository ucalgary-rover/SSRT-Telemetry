#include "labelmanager.hpp"
#include "maplabel.hpp"
#include "roverTracker.hpp"
#include "roverangle.hpp"
#include "rovermqtt.hpp"
#include "sciencesensors.hpp"
#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[]) {
  QGuiApplication app(argc, argv);

  // add the RoverAngle type
  qmlRegisterType<RoverAngle>("SSRTelemetry", 1, 0, "RoverAngle");
  qmlRegisterType<RoverTracker>("com.example", 1, 0, "RoverTracker");
  qmlRegisterType<ScienceSensors>("SSRTelemetry", 1, 0, "ScienceSensors");
  qmlRegisterType<RoverMQTT>("SSRTelemetry", 1, 0, "RoverMQTT");
  qmlRegisterUncreatableType<MapLabel>(
      "com.example", 1, 0, "MapLabel",
      "MapLabel cannot be created directly in QML");
  qmlRegisterType<LabelManager>("com.example", 1, 0, "LabelManager");
  qmlRegisterUncreatableType<MapLabel>(
      "com.example", 1, 0, "LabelType",
      "LabelType is an enum and cannot be created");

  QQmlApplicationEngine engine;
  QObject::connect(
      &engine, &QQmlApplicationEngine::objectCreationFailed, &app,
      []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);
  engine.loadFromModule("SSRTelemetry", "Main");

  return app.exec();
}
