#ifndef SERIALCONNECTION_H
#define SERIALCONNECTION_H

#include <QObject>
#include <QSerialPort>
//#include <QMetaType>

class SerialConnection : public QObject
{
public:
    enum ComStatus {
        UNKNOWN,
        DISCONNECTED,
        CONNECTED
    };
    Q_ENUMS(ComStatus)
    Q_OBJECT

public:
    explicit SerialConnection(QObject *parent = 0);
    virtual ~SerialConnection();

signals:
    void dataReceived(const QString& data) const;
    void errorOccurred(const QString& data) const;
    void statusUpdated(const QString& data) const;
    void statusChanged(ComStatus status) const;

public slots:
    void setupConnection(const QString& dataPath, const QString& port, const QString& baudRate,
                         int dataBits, const QString& parity, const QString& crc,
                         const QString& trigger, const QString& answer);
    void sendText(const QString& text);
    void disconnect();

private slots:
    void readDataFromDevice();
    void handleError(QSerialPort::SerialPortError error);

private:
    int convertToBaudRate(const QString& baudRate);
    QSerialPort::DataBits convertToDataBits(int dataBits);
    QSerialPort::Parity convertToParity(const QString& parity);
    void setTransferData( const QString& dataPath );
    void setCrc( const QString& crc );
    void setTrigger( const QString& trigger );
    void setAnswer( const QString& answer );

private:

    QSerialPort* serialConnection = NULL;

};

//Q_DECLARE_METATYPE(SerialConnection)

#endif // SERIALCONNECTION_H
