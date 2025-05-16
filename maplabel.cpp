#include "maplabel.hpp"

MapLabel::MapLabel(double lat, double lon, QVariantList const &type,
                   QObject *parent)
    : QObject(parent), m_latitude(lat), m_longitude(lon),
      m_labelTypes{
          {"O3", QVariantList{}},
          {"H2", QVariantList{}},
          {"BMK-01",
           QVariantList{"CL-D", "CL-R", "CL-F", "CR-D", "CR-R", "CR-F"}},
          {"BMK-05",
           QVariantList{"CL-D", "CL-R", "CL-F", "CR-D", "CR-R", "CR-F"}},
          {"BMK-10",
           QVariantList{"CL-D", "CL-R", "CL-F", "CR-D", "CR-R", "CR-F"}},
          {"BMK-25",
           QVariantList{"CL-D", "CL-R", "CL-F", "CR-D", "CR-R", "CR-F"}},
          {"NavHazard", QVariantList{}}},

      m_labelColourMap{{"O3", "#BE7309"},       {"H2", "#BE7309"},
                       {"BMK-01", "7D0F9C"},    {"BMK-5", "#11339A"},
                       {"BMK-10", "#BE068D"},   {"BMK-25", "#890C0C"},
                       {"NavHazard", "#0B9E12"}} {

  if (type.size() != 2) {
    // invalid number of arguments
    return;
  } else if (!m_labelTypes.contains(type[0].toString()) ||
             !m_labelTypes[type[0].toString()].toList().contains(type[1])) {
    // invalid arguments
    return;
  }

  QStringList stringType;
  for (const QVariant &v : type) {
    stringType << v.toString();
  }
  m_type = stringType;
}

void MapLabel::setLatitude(double lat) {
  if (m_latitude != lat) {
    m_latitude = lat;
    emit labelChanged();
  }
}

void MapLabel::setLongitude(double lon) {
  if (m_longitude != lon) {
    m_longitude = lon;
    emit labelChanged();
  }
}

void MapLabel::setType(QStringList const &type) {
  if (m_type != type) {
    m_type = type;
    emit labelChanged();
  }
}

QVariantMap MapLabel::labelTypes() const { return m_labelTypes; }
