#ifndef MAPLABEL_H
#define MAPLABEL_H

#include <QObject>

class MapLabel : public QObject {
  Q_OBJECT
  Q_PROPERTY(
      double latitude READ latitude WRITE setLatitude NOTIFY labelChanged)
  Q_PROPERTY(
      double longitude READ longitude WRITE setLongitude NOTIFY labelChanged)
  Q_PROPERTY(LabelType type READ type WRITE setType NOTIFY labelChanged)
public:
  // Define the label types.
  enum LabelType {
    Poison,
    Toxic,
    Physical,
    DamagedLine,
    Ozone,
    POI,
    Hydrogen,
    DamagedRod,
    Reactor
  };
  Q_ENUM(LabelType)

  explicit MapLabel(double lat, double lon, LabelType type,
                    QObject *parent = nullptr)
      : QObject(parent), m_latitude(lat), m_longitude(lon), m_type(type) {}

  double latitude() const { return m_latitude; }
  double longitude() const { return m_longitude; }
  LabelType type() const { return m_type; }
  QString str_type() const;
  Q_INVOKABLE static LabelType type_from_str(QString &s);

  void setLatitude(double lat);

  void setLongitude(double lon);

  void setType(LabelType type);

signals:
  void labelChanged();

private:
  double m_latitude;
  double m_longitude;
  LabelType m_type;
};

#endif // MAPLABEL_H
