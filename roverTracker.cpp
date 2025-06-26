#include "roverTracker.hpp"
#include <QRandomGenerator>

RoverTracker::RoverTracker(QObject *parent)
    : QObject(parent), m_latitude(43.6532), m_longitude(-79.3832) {
  connect(&timer, &QTimer::timeout, this, &RoverTracker::simulateMovement);
  timer.start(1000);
}

void RoverTracker::simulateMovement() {
  // Increase movement delta for more noticeable changes.
  // m_latitude += (QRandomGenerator::global()->bounded(0.001) - 0.0005);
  // m_longitude += (QRandomGenerator::global()->bounded(0.001) - 0.0005);

  m_latitude += 0.002;
  m_longitude += 0.002;
  emit positionChanged();
}
