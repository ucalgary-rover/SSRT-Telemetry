#include "roverTracker.hpp"
#include "rovergpsd.h"
#include <QRandomGenerator>
#include <QDebug>

RoverTracker::RoverTracker(QObject *parent)
    : QObject(parent), m_latitude(43.6532), m_longitude(-79.3832) {

    // Setup gpsd client to fetch gps data over tcp
    auto gps = new RoverGPSD(this);
    // Set update trigger
    connect(gps, &RoverGPSD::locationUpdated, this, [this](double lat, double lon, double alt){
        setCoordinate(lat, lon);
    });
    // Set erorr
    connect(gps, &RoverGPSD::errorOccurred, this, [](const QString& err){
        qWarning() << "GPS error:" << err;
    });
    gps->connectToGpsd();

}

void RoverTracker::simulateMovement() {
    // Increase movement delta for more noticeable changes.
    m_latitude += (QRandomGenerator::global()->bounded(0.001) - 0.0005);
    m_longitude += (QRandomGenerator::global()->bounded(0.001) - 0.0005);
    emit positionChanged();
}

void RoverTracker::setCoordinate(double lat, double lon) {
    m_latitude = lat;
    m_longitude = lon;
}
