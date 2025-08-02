#include "rovermqtt.hpp"
#include <QDebug>
#include <iostream>
#include <unistd.h>

RoverMQTT::RoverMQTT(QObject *parent)
    : QObject(parent), m_client(new QMqttClient(this)) {
  m_client->setAutoKeepAlive(true);
  m_client->setHostname("192.168.1.100");
  m_client->setPort(1883);

  // Connect signals to monitor state changes and incoming messages.
  QObject::connect(m_client, &QMqttClient::connected, [&]() {
    qDebug() << "Connected to broker";
    auto sub = m_client->subscribe(QString("sensors/sensor_1"));
    if(!sub) {
      qWarning() << "SUBSCRIPTION FAILED";
    }
    else {
      qDebug() << "Subscription success";
    }
  });
  // QObject::connect(m_client, &QMqttClient::stateChanged, this,
  //         &RoverMQTT::onStateChanged);
  QObject::connect(m_client, &QMqttClient::messageReceived, this,
          &RoverMQTT::onMessageReceived);


  QObject::connect(m_client, &QMqttClient::disconnected, [&]() {
    qWarning() << "DISCONNECTED";
  });


  m_client->connectToHost();

  // connectToBroker("192.168.1.100", 1883);    // replace with host name and port
  // sleep(2);
  // subscribeTopic("sensors/sensor_1");     // replaced with actual topic name

  //subscribeTopic("sensors/sensor_1");
}

void RoverMQTT::connectToBroker(const QString &host, int port) {
  qDebug() << "Connect to Broker";

  m_client->connectToHost();
  qDebug() << "SUCCESS in broker";
}

void RoverMQTT::publishMessage(const QString &topic, const QString &message) {
  if (m_client->state() == QMqttClient::Connected) {
    m_client->publish(topic, message.toUtf8());
  } else {
    qWarning() << "MQTT client not connected. Cannot publish message.";
  }
}

void RoverMQTT::subscribeTopic(const QString &topic) {
  if (m_client->state() == QMqttClient::Connected) {
    m_client->subscribe(topic);
  } else {
    qWarning() << "MQTT client not connected. Cannot subscribe to topic.";
  }
}

void RoverMQTT::onStateChanged(QMqttClient::ClientState state) {
//   // Update the status property based on the current connection state.
//   qDebug() << "In on state changed";
//   switch (state) {
//   case QMqttClient::Disconnected:
//     m_status = "Disconnected";
//     break;
//   case QMqttClient::Connecting:
//     m_status = "Connecting";
//     break;
//   case QMqttClient::Connected:
//     m_status = "Connected";
//     break;
//   default:
//     m_status = "Unknown";
//     break;
//   }
//   emit statusChanged();
}

void RoverMQTT::onMessageReceived(const QByteArray &message,
                                  const QMqttTopicName &topic) {
  emit messageReceived(topic.name(), QString(message));
}
