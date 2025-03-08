
#include "roverangle.hpp"

// constructor
// TODO: allow danger x and y to be set by the user
RoverAngle::RoverAngle(QObject *parent)
    : QObject{parent}, m_x_angle(0), m_y_angle(0), m_danger_level_x(45),
      m_danger_level_y(45), m_stream_running(true) {
  qDebug("IN ROVER ANGLE CTOR");

  m_get_data_thread = std::thread(&RoverAngle::streamData, this);
  m_monitor_thread = std::thread(&RoverAngle::monitorData, this);
}

// destructor
RoverAngle::~RoverAngle() {
  // stop streaming data
  m_stream_running = false;
  if (m_get_data_thread.joinable()) {
    m_get_data_thread.join();
  }
  if (m_monitor_thread.joinable()) {
    m_monitor_thread.join();
  }
}

qreal RoverAngle::x_angle() const { return m_x_angle; }

void RoverAngle::setXAngle(qreal newX_angle) {
  if (qFuzzyCompare(m_x_angle, newX_angle))
    return;
  m_x_angle = newX_angle;
  emit xAngleChanged();
}

qreal RoverAngle::y_angle() const { return m_y_angle; }

void RoverAngle::setYAngle(qreal newY_angle) {
  if (qFuzzyCompare(m_y_angle, newY_angle))
    return;
  m_y_angle = newY_angle;
  emit yAngleChanged();
}

qreal RoverAngle::danger_level_x() const { return m_danger_level_x; }

qreal RoverAngle::danger_level_y() const { return m_danger_level_y; }

// this function will connect to the stream of data coming from the IMU
// currently it creates dummy data to simulate a stream
void RoverAngle::streamData() {
  const int updateTimeMs = 150;

  auto startTime = std::chrono::steady_clock::now();
  while (m_stream_running) {
    // calculated elapsed time in seconds
    auto elapsed = std::chrono::steady_clock::now() - startTime;
    qreal elapsedSeconds = std::chrono::duration<qreal>(elapsed).count();

    // calculate angle
    qreal newXAngle = std::sin(elapsedSeconds);
    qreal newYAngle = std::cos(elapsedSeconds);

    // convert rads to degs
    newXAngle = newXAngle * 180 / M_PI;
    newYAngle = newYAngle * 180 / M_PI;

    // update angles
    setXAngle(newXAngle);
    setYAngle(newYAngle);

    // wait for 0.5s
    std::this_thread::sleep_for(std::chrono::milliseconds(updateTimeMs));
  }
}

// watch the x and y angles to see if they reach a dangerous level
void RoverAngle::monitorData() {
  while (m_stream_running) {
    bool x_in_danger = abs(x_angle()) > danger_level_x();
    bool y_in_danger = abs(y_angle()) > danger_level_y();

    // qDebug("Current x danger: %i, current y danger: %i", x_danger(),
    // y_danger());

    if (x_in_danger && y_in_danger) {
      qDebug("Both angles of the rover are in danger of tipping!");
      set_x_danger(true);
      set_y_danger(true);
    } else if (x_in_danger) {
      qDebug("X angle in danger of tipping ");
      set_x_danger(true);
    } else if (y_in_danger) {
      qDebug("Y angle in danger of tipping");
      set_y_danger(true);
    }

    // wait for 0.5s
    std::this_thread::sleep_for(std::chrono::milliseconds(500));
  }
}

bool RoverAngle::x_danger() const { return m_x_danger; }

bool RoverAngle::y_danger() const { return m_y_danger; }

void RoverAngle::set_x_danger(bool in_danger) {
  if (m_x_danger == in_danger) {
    return;
  }
  m_x_danger = in_danger;
  emit xDangerChanged();
}

void RoverAngle::set_y_danger(bool in_danger) {
  if (m_y_danger == in_danger) {
    return;
  }
  m_y_danger = in_danger;
  emit yDangerChanged();
}
