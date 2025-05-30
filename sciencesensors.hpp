#ifndef SCIENCESENSORS_H
#define SCIENCESENSORS_H

#include <QObject>

// the below includes are only used for simulated data
#include <chrono>
#include <cstdlib>
#include <thread>

class ScienceSensors : public QObject {
  Q_OBJECT
  Q_PROPERTY(qreal decay_coeff READ decay_coeff WRITE setDelayCoeff NOTIFY
                 delayCoeffChanged)
  Q_PROPERTY(
      qreal half_life READ half_life WRITE setHalfLife NOTIFY halfLifeChanged)
  Q_PROPERTY(qreal total_energy READ total_energy WRITE setTotalEnergy NOTIFY
                 totalEnergyChanged)
  Q_PROPERTY(qreal uncertainty READ uncertainty WRITE setUncertainty NOTIFY
                 uncertaintyChanged)
  Q_PROPERTY(
      qreal ozone_ppm READ ozone_ppm WRITE setOzonePPM NOTIFY ozonePPMChanged)
  Q_PROPERTY(qreal h2_ppm READ h2_ppm WRITE setH2PPM NOTIFY h2PPMChanged)
  Q_PROPERTY(qreal atomic_radius READ atomic_radius WRITE setAtomicRadius NOTIFY
                 atomicRadiusChanged)
  Q_PROPERTY(qreal radioactivity READ radioactivity WRITE setRadioactivity
                 NOTIFY radioactivityChanged)

public:
  explicit ScienceSensors(QObject *parent = nullptr);
  ~ScienceSensors();

  qreal decay_coeff() const;
  void setDelayCoeff(qreal newDecay_coeff);

  qreal half_life() const;
  void setHalfLife(qreal newHalf_life);

  qreal total_energy() const;
  void setTotalEnergy(qreal newTotal_energy);

  qreal uncertainty() const;
  void setUncertainty(qreal newUncertainty);

  qreal ozone_ppm() const;
  void setOzonePPM(qreal newOzone_ppm);

  qreal h2_ppm() const;
  void setH2PPM(qreal newH2_ppm);

  qreal atomic_radius() const;
  void setAtomicRadius(qreal newAtomic_radius);

  qreal radioactivity() const;
  void setRadioactivity(qreal newRadioactivity);

signals:
  void delayCoeffChanged();
  void halfLifeChanged();
  void totalEnergyChanged();
  void uncertaintyChanged();
  void ozonePPMChanged();
  void h2PPMChanged();
  void atomicRadiusChanged();
  void radioactivityChanged();

private:
  qreal m_decay_coeff;
  qreal m_half_life;
  qreal m_total_energy;
  qreal m_uncertainty;
  qreal m_ozone_ppm;
  qreal m_h2_ppm;
  qreal m_atomic_radius;
  qreal m_radioactivity;

  bool m_stream_running;
  std::thread m_get_data_thread;

  void streamData();
};

#endif // SCIENCESENSORS_H
