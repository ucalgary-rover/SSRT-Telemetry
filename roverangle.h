#ifndef ROVERANGLE_H
#define ROVERANGLE_H

#include <QObject>
#include <QDebug>
#include <cmath>

// the below includes are only used for simulated data
#include <chrono>
#include <thread>


class RoverAngle : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal x_angle READ x_angle WRITE setXAngle NOTIFY xAngleChanged)
    Q_PROPERTY(qreal y_angle READ y_angle WRITE setYAngle NOTIFY yAngleChanged)
    Q_PROPERTY(qreal danger_level_x READ danger_level_x CONSTANT FINAL)
    Q_PROPERTY(qreal danger_level_y READ danger_level_y CONSTANT FINAL)
    Q_PROPERTY(bool x_danger READ x_danger WRITE set_x_danger NOTIFY xDangerChanged)
    Q_PROPERTY(bool y_danger READ y_danger WRITE set_y_danger NOTIFY yDangerChanged)


public:
    explicit RoverAngle(QObject *parent = nullptr);
    ~RoverAngle();

    qreal x_angle() const;
    void setXAngle(qreal newX_angle);

    qreal y_angle() const;
    void setYAngle(qreal newY_angle);

    qreal danger_level_x() const;
    qreal danger_level_y() const;

    bool x_danger() const;
    bool y_danger() const;
    Q_INVOKABLE void set_x_danger(bool in_danger);
    Q_INVOKABLE void set_y_danger(bool in_danger);

signals:
    void xAngleChanged();
    void yAngleChanged();

    void xDangerChanged();
    void yDangerChanged();

private:
    qreal m_x_angle;
    qreal m_y_angle;

    qreal m_danger_level_x;
    qreal m_danger_level_y;
    bool m_x_danger;
    bool m_y_danger;

    bool m_stream_running;
    std::thread m_get_data_thread;
    std::thread m_monitor_thread;

    void streamData();
    void monitorData();
};

#endif // ROVERANGLE_H
