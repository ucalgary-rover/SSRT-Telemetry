#ifndef MAPLABEL_H
#define MAPLABEL_H

#include <QObject>
#include <QVariantMap>

class MapLabel : public QObject {
  Q_OBJECT
  Q_PROPERTY(
      double latitude READ latitude WRITE setLatitude NOTIFY labelChanged)
  Q_PROPERTY(
      double longitude READ longitude WRITE setLongitude NOTIFY labelChanged)
  Q_PROPERTY(QStringList type READ type WRITE setType NOTIFY labelChanged)
  Q_PROPERTY(QMap labelTypes READ labelTypes CONSTANT FINAL)
public:
  explicit MapLabel(double lat, double lon, const QStringList &type,
                    QObject *parent = nullptr);

  double latitude() const { return m_latitude; }
  double longitude() const { return m_longitude; }
  QStringList type() const { return m_type; }

  void setLatitude(double lat);

  void setLongitude(double lon);

  void setType(const QStringList &type);

  QMap<QString, QStringList> labelTypes() const;

signals:
  void labelChanged();

private:
  double m_latitude;
  double m_longitude;
  QStringList m_type;
  QMap<QString, QStringList> m_labelTypes;
  std::map<std::string, std::string> m_labelColourMap;
};

#endif // MAPLABEL_H
