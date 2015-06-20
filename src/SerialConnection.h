#ifndef SERIALCONNECTION_H
#define SERIALCONNECTION_H

#include <QObject>
#include <QSerialPort>

class SerialConnection : public QObject
{
    Q_OBJECT
public:
    explicit SerialConnection(QObject *parent = 0);

signals:
    void dataReceived( const QString& data ) const;
    void errorOccurred( const QString& data ) const;
    void statusUpdated( const QString& data ) const;

public slots:
    void setupConnection( const QString& dataPath, const QString& port, const QString& baudRate,
                          int dataBits, const QString& parity, const QString& crc,
                          const QString& trigger, const QString& answer );

private:

    static int convertToBaudRate( const QString& baudRate );
    static QSerialPort::DataBits convertToDataBits( int dataBits );
    static QSerialPort::Parity convertToParity( const QString& parity );

};

#endif // SERIALCONNECTION_H
