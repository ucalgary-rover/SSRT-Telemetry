#ifndef ROVERTRACKER_H
#define ROVERTRACKER_H

#include <QObject>
#include <QTimer>

class RoverTracker : public QObject {
    Q_OBJECT
    Q_PROPERTY(double latitude READ latitude NOTIFY positionChanged)
    Q_PROPERTY(double longitude READ longitude NOTIFY positionChanged)

public:
    explicit RoverTracker(QObject *parent = nullptr);

    double latitude() const { return m_latitude; }
    double longitude() const { return m_longitude; }
    void setCoordinate(double lat, double lon);

signals:
    void positionChanged();

private slots:
    void simulateMovement();

private:
    QTimer timer;
    double m_latitude;
    double m_longitude;
};

#endif // ROVERTRACKER_H
