#include "imudata.hpp"
#include "labelmanager.hpp"
#include "maplabel.hpp"
#include "roverTracker.hpp"
#include "roverangle.hpp"
#include "rovermqtt.hpp"
#include "sciencesensors.hpp"
#include <QGuiApplication>
#include <QQmlApplicationEngine>

// register the cpp classes as singletons to be used throughout the app
static QObject *roverMqttSingletonProvider(QQmlEngine *, QJSEngine *) {
  return new RoverMQTT();
}

static QObject *roverTrackerSingletonProvider(QQmlEngine *, QJSEngine *) {
  return new RoverTracker();
}

static QObject *scienceSensorsSingletonProvider(QQmlEngine *, QJSEngine *) {
  return new ScienceSensors();
}

int main(int argc, char *argv[]) {
  QGuiApplication app(argc, argv);

  // add the RoverAngle type
  qmlRegisterType<RoverAngle>("SSRTelemetry", 1, 0, "RoverAngle");
  qmlRegisterSingletonType<RoverTracker>("SSRTelemetry", 1, 0, "RoverTracker",
                                         roverTrackerSingletonProvider);
  qmlRegisterSingletonType<ScienceSensors>(
      "SSRTelemetry", 1, 0, "ScienceSensors", scienceSensorsSingletonProvider);
  qmlRegisterSingletonType<RoverMQTT>("SSRTelemetry", 1, 0, "RoverMQTT",
                                      roverMqttSingletonProvider);
  qmlRegisterUncreatableType<MapLabel>(
      "SSRTelemetry", 1, 0, "MapLabel",
      "MapLabel cannot be created directly in QML");
  qmlRegisterType<LabelManager>("SSRTelemetry", 1, 0, "LabelManager");
  qmlRegisterUncreatableType<MapLabel>(
      "SSRTelemetry", 1, 0, "LabelType",
      "LabelType is an enum and cannot be created");
  qmlRegisterType<IMUData>("SSRTelemetry", 1, 0, "IMUData");

  QQmlApplicationEngine engine;
  QObject::connect(
      &engine, &QQmlApplicationEngine::objectCreationFailed, &app,
      []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);
  engine.loadFromModule("SSRTelemetry", "Main");

  return app.exec();
}
