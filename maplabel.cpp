#include "maplabel.hpp"
#include <QCoreApplication>
#include <QDir>
#include <QFile>
#include <QList>
#include <QObject>
#include <QTextStream>
#include <ctime>
#include <string>
#include <unordered_map>

MapLabel::MapLabel(double lat, double lon, QStringList const &type,
                   QObject *parent)
    : QObject(parent), m_latitude(lat), m_longitude(lon),
      m_labelTypes{
          {"O3", QStringList{}},
          {"H2", QStringList{}},
          {"BMK-01",
           QStringList{"CL-D", "CL-R", "CL-F", "CR-D", "CR-R", "CR-F"}},
          {"BMK-05",
           QStringList{"CL-D", "CL-R", "CL-F", "CR-D", "CR-R", "CR-F"}},
          {"BMK-10",
           QStringList{"CL-D", "CL-R", "CL-F", "CR-D", "CR-R", "CR-F"}},
          {"BMK-25",
           QStringList{"CL-D", "CL-R", "CL-F", "CR-D", "CR-R", "CR-F"}},
          {"NavHazard", QStringList{}}},

      m_labelColourMap{{"O3", "#BE7309"},       {"H2", "#BE7309"},
                       {"BMK-01", "7D0F9C"},    {"BMK-5", "#11339A"},
                       {"BMK-10", "#BE068D"},   {"BMK-25", "#890C0C"},
                       {"NavHazard", "#0B9E12"}} {

  if (type.size() != 2) {
    // invalid number of arguments
    return;
  } else if (!m_labelTypes.count(type[0]) ||
             !m_labelTypes[type[0]].contains(type[1])) {
    // invalid arguments
    return;
  }

  m_type = type;
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

QMap<QString, QStringList> MapLabel::labelTypes() const { return m_labelTypes; }
