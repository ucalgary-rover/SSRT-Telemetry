#include "rovertracker.h"
#include <QRandomGenerator>

RoverTracker::RoverTracker(QObject *parent)
    : QObject(parent),
    m_latitude(43.6532),
    m_longitude(-79.3832)
{
    connect(&timer, &QTimer::timeout, this, &RoverTracker::simulateMovement);
    timer.start(1000);
}

void RoverTracker::simulateMovement()
{
    m_latitude += (QRandomGenerator::global()->bounded(0.0001) - 0.00005);
    m_longitude += (QRandomGenerator::global()->bounded(0.0001) - 0.00005);
    emit positionChanged();
}
