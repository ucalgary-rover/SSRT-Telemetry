#ifndef LABELMANAGER_H
#define LABELMANAGER_H

#include "maplabel.hpp"
#include <QList>
#include <QObject>

class LabelManager : public QObject {
  Q_OBJECT
  Q_PROPERTY(int labelCount READ labelCount NOTIFY labelsUpdated)
public:
  explicit LabelManager(QObject *parent = nullptr) : QObject(parent) {}

  // Add a new label at the given coordinate with the specified type.
  Q_INVOKABLE void addLabel(double latitude, double longitude,
                            MapLabel::LabelType type) {
    MapLabel *newLabel = new MapLabel(latitude, longitude, type, this);
    qDebug("Map label: ", type);
    m_labels.append(newLabel);
    emit labelsUpdated();
  }

  // Returns a list of labels filtered by type.
  Q_INVOKABLE QList<QObject *> filterLabels(MapLabel::LabelType type) const {
    QList<QObject *> filtered;
    for (QObject *obj : m_labels) {
      MapLabel *label = qobject_cast<MapLabel *>(obj);
      if (label && label->type() == type)
        filtered.append(label);
    }
    return filtered;
  }

  // Returns all labels.
  Q_INVOKABLE QList<QObject *> allLabels() const { return m_labels; }

  int labelCount() const { return m_labels.count(); }

signals:
  void labelsUpdated();

private:
  QList<QObject *> m_labels;
};

#endif // LABELMANAGER_H
