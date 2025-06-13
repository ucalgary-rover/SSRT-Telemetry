#include "imudata.hpp"

IMUData::IMUData(QObject *parent) : QObject{parent}, m_stream_running(true) {
  m_get_data_thread = std::thread(&IMUData::streamData, this);
}

IMUData::~IMUData() {
  // stop streaming data
  m_stream_running = false;
  if (m_get_data_thread.joinable()) {
    m_get_data_thread.join();
  }
}

qreal IMUData::heading_angle() const { return m_heading_angle; }

QString IMUData::heading_cardinal() const { return m_heading_cardinal; }

void IMUData::setHeadingAngle(qreal new_angle) {
  if (qFuzzyCompare(m_heading_angle, new_angle)) {
    return;
  }
  m_heading_angle = new_angle;
  emit headingAngleChanged();
}

void IMUData::setHeadingCardinal(QString &new_heading) {
  if (m_heading_cardinal == new_heading) {
    return;
  }
  m_heading_cardinal = new_heading;
  emit headingCardinalChanged();
}

// placeholder function that will connect to MQTT server
void IMUData::streamData() {
  const int updateTimeMs = 1000;
  // auto startTime = std::chrono::steady_clock::now();

  std::random_device rd;
  std::mt19937 gen(rd());
  std::uniform_real_distribution<> dis(-1.3, 1.3);
  std::uniform_real_distribution<> accel_dis(-10, 10);

  while (m_stream_running) {
    // auto elapsed = std::chrono::steady_clock::now() - startTime;

    double mag_x = dis(gen);
    double mag_y = dis(gen);
    double mag_z = dis(gen);

    float accel_x = accel_dis(gen);
    float accel_y = accel_dis(gen);
    float accel_z = accel_dis(gen);

    float heading =
        computeHeading(accel_x, accel_y, accel_z, mag_x, mag_y, mag_z);
    setHeadingAngle(heading);
    setHeadingCardinal(getCardinalDirection(heading));

    std::this_thread::sleep_for(std::chrono::milliseconds(updateTimeMs));
  }
}

// Utility function to normalize angle to 0–360
float IMUData::normalizeHeading(float heading_deg) {
  if (heading_deg < 0)
    heading_deg += 360.0f;
  if (heading_deg >= 360)
    heading_deg -= 360.0f;
  return heading_deg;
}

// Optional: convert heading degrees to cardinal direction
QString IMUData::getCardinalDirection(float heading_angle) {
  const char *directions[] = {"N", "NE", "E", "SE", "S", "SW", "W", "NW"};
  int index = static_cast<int>((heading_angle + 22.5f) / 45.0f) % 8;
  return directions[index];
}

// Main function: computes heading in degrees
float IMUData::computeHeading(float accel_x, float accel_y, float accel_z,
                              float mag_x, float mag_y, float mag_z) {
  // Compute roll and pitch from accelerometer
  float roll = atan2(accel_y, accel_z);
  float pitch = atan2(-accel_x, sqrt(accel_y * accel_y + accel_z * accel_z));

  // Compensate magnetometer readings
  float mag_x_comp = mag_x * cos(pitch) + mag_z * sin(pitch);
  float mag_y_comp = mag_x * sin(roll) * sin(pitch) + mag_y * cos(roll) -
                     mag_z * sin(roll) * cos(pitch);

  // Compute heading (in radians), then convert to degrees
  float heading_rad = atan2(mag_y_comp, mag_x_comp);
  float heading_deg = heading_rad * (180.0f / M_PI);

  return normalizeHeading(heading_deg);
}
