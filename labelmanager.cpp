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

void LabelManager::saveToTxt() const {
  qDebug("HERE!!");

  // current date & time
  time_t time = std::time(NULL);
  char timeChar[std::size("yyyy-mm-ddThh:mm:ssZ")];
  strftime(std::data(timeChar), std::size(timeChar), "%FT%TZ",
           localtime(&time));
  std::string timeString = timeChar;
  timeString.replace(13, 1, 1, ',');
  timeString.replace(16, 1, 1, ',');
  timeString.append(".txt");
  timeString = "saves/" + timeString;

  QString project_directory = QCoreApplication::applicationDirPath();
  QDir dir(project_directory);
  qDebug() << "Before path: " << dir << "\n";
  if (dir.cdUp()) {
    if (dir.cdUp()) {                // up to project root
      if (!QDir("saves").exists()) { // ensure folder exists
        QDir().mkdir("saves");
      }

      QString filePath = dir.filePath(timeString.c_str());

      QFile file(filePath);
      if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream out(&file);
        out << "Lat, Long - Type (number)\n";
        for (const QObject *labelObj : m_labels) {
          const MapLabel *label = qobject_cast<const MapLabel *>(labelObj);
          if (label) {
            out << label->latitude() << "," << label->longitude() << " - "
                << label->str_type() << "\n";
          }
        }
        file.close();
        qDebug() << "Finished writing to file " << filePath;
      } else {
        qWarning() << "Failed to open file for writing: " << filePath;
      }
    } else {
      qWarning() << "Failed to find project directory\n";
    }
  }
}

MapLabel *LabelManager::createDummyMapLabel() {
  MapLabel *l = new MapLabel(0, 0, MapLabel::Poison, this);
  return l;
}

int LabelManager::labelCount() const { return m_labels.count(); }
