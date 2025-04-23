#include "maplabel.hpp"

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
