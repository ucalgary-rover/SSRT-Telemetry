#include "rovermqtt.hpp"
#include <QDebug>

RoverMQTT::RoverMQTT(QObject *parent)
    : QObject(parent),
    m_client(new QMqttClient(this))
{
    m_client->setAutoKeepAlive(true);

    // Connect signals to monitor state changes and incoming messages.
    connect(m_client, &QMqttClient::stateChanged, this, &RoverMQTT::onStateChanged);
    connect(m_client, &QMqttClient::messageReceived, this, &RoverMQTT::onMessageReceived);
}

void RoverMQTT::connectToBroker(const QString &host, int port)
{
    m_client->setHostname(host);
    m_client->setPort(port);
    m_client->connectToHost();
}

void RoverMQTT::publishMessage(const QString &topic, const QString &message)
{
    if (m_client->state() == QMqttClient::Connected) {
        m_client->publish(topic, message.toUtf8());
    } else {
        qWarning() << "MQTT client not connected. Cannot publish message.";
    }
}

void RoverMQTT::subscribeTopic(const QString &topic)
{
    if (m_client->state() == QMqttClient::Connected) {
        m_client->subscribe(topic);
    } else {
        qWarning() << "MQTT client not connected. Cannot subscribe to topic.";
    }
}

void RoverMQTT::onStateChanged(QMqttClient::ClientState state)
{
    // Update the status property based on the current connection state.
    switch (state) {
    case QMqttClient::Disconnected:
        m_status = "Disconnected";
        break;
    case QMqttClient::Connecting:
        m_status = "Connecting";
        break;
    case QMqttClient::Connected:
        m_status = "Connected";
        break;
    default:
        m_status = "Unknown";
        break;
    }
    emit statusChanged();
}

void RoverMQTT::onMessageReceived(const QByteArray &message, const QMqttTopicName &topic)
{
    emit messageReceived(topic.name(), QString(message));
}
