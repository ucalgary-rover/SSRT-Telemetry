#ifndef ROVERMQTT_H
#define ROVERMQTT_H

#include <QObject>
#include <QMqttClient>

class RoverMQTT : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString status READ status NOTIFY statusChanged)

public:
    explicit RoverMQTT(QObject *parent = nullptr);

    QString status() const { return m_status; }

    Q_INVOKABLE void connectToBroker(const QString &host, int port);
    Q_INVOKABLE void publishMessage(const QString &topic, const QString &message);
    Q_INVOKABLE void subscribeTopic(const QString &topic);

signals:
    void statusChanged();
    void messageReceived(const QString &topic, const QString &message);

private slots:
    void onStateChanged(QMqttClient::ClientState state);
    void onMessageReceived(const QByteArray &message, const QMqttTopicName &topic);

private:
    QMqttClient *m_client;
    QString m_status;
};

#endif // ROVERMQTT_H
