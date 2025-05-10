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

QString MapLabel::str_type() const {
  switch (m_type) {
  case 0:
    return QString("Poison");
  case 1:
    return QString("Toxic");
  case 2:
    return QString("Physical");
  case 3:
    return QString("Damaged Line");
  case 4:
    return QString("Ozone");
  case 5:
    return QString("POI");
  case 6:
    return QString("Hydrogen");
  case 7:
    return QString("Damaged Rod");
  case 8:
    return QString("Reactor");
  }
  return QString("N/A");
}

MapLabel::LabelType MapLabel::type_from_str(QString &s) {
  std::unordered_map<std::string, int> translations = {
      {"Poison", 0},       {"Toxic", 1},       {"Physical", 2},
      {"Damaged Line", 3}, {"Ozone", 4},       {"POI", 5},
      {"Hydrogen", 6},     {"Damaged Rod", 7}, {"Reactor", 8}};

  int enum_int = translations[s.toStdString()];
  return static_cast<MapLabel::LabelType>(enum_int);
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

void MapLabel::setType(LabelType type) {
  if (m_type != type) {
    m_type = type;
    emit labelChanged();
  }
}
