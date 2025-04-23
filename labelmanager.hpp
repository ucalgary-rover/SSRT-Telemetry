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
                            MapLabel::LabelType type);

  // Returns a list of labels filtered by type.
  Q_INVOKABLE QList<QObject *> filterLabels(MapLabel::LabelType type) const;

  // Returns all labels.
  Q_INVOKABLE QList<QObject *> allLabels() const;

  int labelCount() const;

signals:
  void labelsUpdated();

private:
  QList<QObject *> m_labels;
};

#endif // LABELMANAGER_H
