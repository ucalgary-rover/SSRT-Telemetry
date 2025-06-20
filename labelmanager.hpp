#ifndef LABELMANAGER_H
#define LABELMANAGER_H

#include "maplabel.hpp"
#include <QCoreApplication>
#include <QDir>
#include <QFile>
#include <QList>
#include <QObject>
#include <QTextStream>
#include <ctime>
#include <string>

class LabelManager : public QObject {
  Q_OBJECT
  Q_PROPERTY(int labelCount READ labelCount NOTIFY labelsUpdated)
public:
  explicit LabelManager(QObject *parent = nullptr);

  // Add a new label at the given coordinate with the specified type.
  Q_INVOKABLE void addLabel(double latitude, double longitude,
                            QStringList type);

  // Returns a list of labels filtered by type.
  Q_INVOKABLE QList<QObject *> filterLabels(const QString &type) const;

  // Returns all labels.
  Q_INVOKABLE QList<QObject *> allLabels() const;

  Q_INVOKABLE void saveToTxt() const;

  Q_INVOKABLE MapLabel *createDummyMapLabel() const;

  Q_INVOKABLE QVariantMap getAllLabels() const;

  int labelCount() const;

signals:
  void labelsUpdated();

private:
  QList<QObject *> m_labels;
};

#endif // LABELMANAGER_H
