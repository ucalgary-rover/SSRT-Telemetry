#include "labelmanager.hpp"

void LabelManager::addLabel(double latitude, double longitude,
                            MapLabel::LabelType type) {
  MapLabel *newLabel = new MapLabel(latitude, longitude, type, this);
  // qDebug("Map label: ", type);
  m_labels.append(newLabel);
  emit labelsUpdated();
}

QList<QObject *> LabelManager::filterLabels(MapLabel::LabelType type) const {
  QList<QObject *> filtered;
  for (QObject *obj : m_labels) {
    MapLabel *label = qobject_cast<MapLabel *>(obj);
    if (label && label->type() == type)
      filtered.append(label);
  }
  return filtered;
}

QList<QObject *> LabelManager::allLabels() const { return m_labels; }

int LabelManager::labelCount() const { return m_labels.count(); }
