#ifndef IMUDATA_HPP
#define IMUDATA_HPP

#include <QObject>
// included for simulated data
#include <chrono>
#include <cstdlib>
#include <random>
#include <thread>

class IMUData : public QObject {
  Q_OBJECT
  Q_PROPERTY(qreal heading_angle READ heading_angle WRITE setHeadingAngle NOTIFY
                 headingAngleChanged)
  Q_PROPERTY(QString heading_cardinal READ heading_cardinal WRITE
                 setHeadingCardinal NOTIFY headingCardinalChanged)
public:
  explicit IMUData(QObject *parent = nullptr);
  ~IMUData();

  qreal heading_angle() const;
  void setHeadingAngle(qreal new_angle);

  QString heading_cardinal() const;
  void setHeadingCardinal(QString new_heading);

private:
  qreal m_heading_angle;
  QString m_heading_cardinal;

  void streamData();

  bool m_stream_running;
  std::thread m_get_data_thread;

  float normalizeHeading(float heading_deg);
  QString getCardinalDirection(float heading_angle);
  float computeHeading(float accel_x, float accel_y, float accel_z, float mag_x,
                       float mag_y, float mag_z);

signals:
  void headingAngleChanged();
  void headingCardinalChanged();
};

#endif // IMUDATA_HPP
