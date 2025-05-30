#include "sciencesensors.hpp"

// constructor
ScienceSensors::ScienceSensors(QObject *parent)
    : QObject{parent}, m_decay_coeff(0), m_half_life(0), m_total_energy(0),
      m_uncertainty(0), m_ozone_ppm(0), m_h2_ppm(0), m_atomic_radius(0),
      m_radioactivity(0), m_stream_running(true) {
  srand(time(0));

  m_get_data_thread = std::thread(&ScienceSensors::streamData, this);
}

// destructor
ScienceSensors::~ScienceSensors() {
  // stop streaming data
  m_stream_running = false;
  if (m_get_data_thread.joinable()) {
    m_get_data_thread.join();
  }
}

qreal ScienceSensors::decay_coeff() const { return m_decay_coeff; }

void ScienceSensors::setDelayCoeff(qreal newDecay_coeff) {
  if (qFuzzyCompare(m_decay_coeff, newDecay_coeff))
    return;
  m_decay_coeff = newDecay_coeff;
  emit delayCoeffChanged();
}

qreal ScienceSensors::half_life() const { return m_half_life; }

void ScienceSensors::setHalfLife(qreal newHalf_life) {
  if (qFuzzyCompare(m_half_life, newHalf_life))
    return;
  m_half_life = newHalf_life;
  emit halfLifeChanged();
}

qreal ScienceSensors::total_energy() const { return m_total_energy; }

void ScienceSensors::setTotalEnergy(qreal newTotal_energy) {
  if (qFuzzyCompare(m_total_energy, newTotal_energy))
    return;
  m_total_energy = newTotal_energy;
  emit totalEnergyChanged();
}

qreal ScienceSensors::uncertainty() const { return m_uncertainty; }

void ScienceSensors::setUncertainty(qreal newUncertainty) {
  if (qFuzzyCompare(m_uncertainty, newUncertainty))
    return;
  m_uncertainty = newUncertainty;
  emit uncertaintyChanged();
}

qreal ScienceSensors::ozone_ppm() const { return m_ozone_ppm; }

void ScienceSensors::setOzonePPM(qreal newOzone_ppm) {
  if (qFuzzyCompare(m_ozone_ppm, newOzone_ppm))
    return;
  m_ozone_ppm = newOzone_ppm;
  emit ozonePPMChanged();
}

qreal ScienceSensors::h2_ppm() const { return m_h2_ppm; }

void ScienceSensors::setH2PPM(qreal newH2_ppm) {
  if (qFuzzyCompare(m_h2_ppm, newH2_ppm))
    return;
  m_h2_ppm = newH2_ppm;
  emit h2PPMChanged();
}

qreal ScienceSensors::atomic_radius() const { return m_atomic_radius; }

void ScienceSensors::setAtomicRadius(qreal newAtomic_radius) {
  if (qFuzzyCompare(m_atomic_radius, newAtomic_radius))
    return;
  m_atomic_radius = newAtomic_radius;
  emit atomicRadiusChanged();
}

qreal ScienceSensors::radioactivity() const { return m_radioactivity; }

void ScienceSensors::setRadioactivity(qreal newRadioactivity) {
  if (qFuzzyCompare(m_radioactivity, newRadioactivity))
    return;
  m_radioactivity = newRadioactivity;
  emit radioactivityChanged();
}

// this function will connect to the stream of data coming from the IMU
// currently it creates dummy data to simulate a stream (all between 0-100)
void ScienceSensors::streamData() {
  const int updateTimeMs = 500;

  while (m_stream_running) {
    // generate new values
    setDelayCoeff(rand() % 101);
    setHalfLife(rand() % 101);
    setTotalEnergy(rand() % 101);
    setOzonePPM(rand() % 101);
    setH2PPM(rand() % 101);
    setAtomicRadius(rand() % 101);
    setRadioactivity(rand() % 101);
    setUncertainty(rand() % 101);

    // wait for 0.5s
    std::this_thread::sleep_for(std::chrono::milliseconds(updateTimeMs));
  }
}
