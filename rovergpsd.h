#ifndef ROVERGPSD_H
#define ROVERGPSD_H

#include <QObject>
#include <QTcpSocket>
#include <QJsonDocument>
#include <QJsonObject>

class RoverGPSD : public QObject
{
    Q_OBJECT
public:
    explicit RoverGPSD(QObject *parent = nullptr);
    void connectToGpsd(const QString& host = "localhost", quint16 port = 2947);
    void disconnect();

signals:
    void locationUpdated(double latitude, double longitude, double altitude);
    void errorOccurred(const QString& error);

private slots:
    void onConnected();
    void onReadyRead();
    void onErrorOccurred(QAbstractSocket::SocketError socketError);

private:
QTcpSocket m_socket;
};

#endif // ROVERGPSD_H
