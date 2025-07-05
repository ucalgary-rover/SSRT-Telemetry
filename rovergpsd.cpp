#include "rovergpsd.h"
#include <QDebug>

RoverGPSD::RoverGPSD(QObject *parent)
    : QObject{parent}
{
    connect(&m_socket, &QTcpSocket::connected, this, &RoverGPSD::onConnected);
    connect(&m_socket, &QTcpSocket::readyRead, this, &RoverGPSD::onReadyRead);
    connect(&m_socket, qOverload<QAbstractSocket::SocketError>(&QTcpSocket::errorOccurred),
            this, &RoverGPSD::onErrorOccurred);
}


void RoverGPSD::connectToGpsd(const QString& host, quint16 port)
{
    if (m_socket.state() != QAbstractSocket::UnconnectedState)
        m_socket.disconnectFromHost();

    m_socket.connectToHost(host, port);
}

void RoverGPSD::disconnect()
{
    m_socket.disconnectFromHost();
}

void RoverGPSD::onConnected()
{
    // Enable JSON output from gpsd
    m_socket.write("?WATCH={\"enable\":true,\"json\":true}\n");
}

void RoverGPSD::onReadyRead()
{
    while (m_socket.canReadLine()) {
        QByteArray line = m_socket.readLine().trimmed();
        auto doc = QJsonDocument::fromJson(line);
        if (!doc.isObject()) continue;

        const auto obj = doc.object();
        if (obj.value("class").toString() == "TPV") {
            double lat = obj.value("lat").toDouble(std::numeric_limits<double>::quiet_NaN());
            double lon = obj.value("lon").toDouble(std::numeric_limits<double>::quiet_NaN());
            double alt = obj.value("alt").toDouble(0.0);
            if (!std::isnan(lat) && !std::isnan(lon)) {
                emit locationUpdated(lat, lon, alt);
            }
        }
        else {
            if (!doc.isNull()) {
                qWarning() << "Missing positional data...unable to fetch satellite lock";
            }
            else {
                qWarning() << "Missing data from GNSS device";
            }

        }
    }
}

void RoverGPSD::onErrorOccurred(QAbstractSocket::SocketError socketError)
{
    Q_UNUSED(socketError);
    emit errorOccurred(m_socket.errorString());
}
