#include "SerialConnection.h"
#include <QDebug>
#include <QFile>
#include <QFileInfo>
#include <QtQml>




SerialConnection::SerialConnection(QObject *parent) : QObject(parent)
{
    qmlRegisterType<SerialConnection>( "UartFlasher.SerialConnection", 1, 0, "SerialConnection" );
}

SerialConnection::~SerialConnection()
{
    if( serialConnection != NULL ) disconnect();
}

void SerialConnection::setupConnection( const QString& dataPath, const QString& port, const QString& baudRate,
                                        int dataBits, const QString& parity, const QString& crc,
                                        const QString& trigger, const QString& answer )
{
    qDebug() << "setupConnection()";
    setTransferData(dataPath);
    setCrc(crc);
    setTrigger(trigger);
    setAnswer(answer);

    if( serialConnection != NULL )
    {
        emit errorOccurred( tr("Cannot setup connection twice!") );
        return;
    }

    serialConnection = new QSerialPort(port, this);
    serialConnection->setBaudRate(convertToBaudRate(baudRate));
    serialConnection->setDataBits(convertToDataBits(dataBits));
    serialConnection->setParity(  convertToParity(parity));
    //serialConnection->setStopBits();
    serialConnection->setFlowControl(QSerialPort::HardwareControl);
    if( !serialConnection->open(QSerialPort::ReadWrite) )
    {
        emit errorOccurred( tr("Failed to open serial port '%1'!").arg(port) );
        disconnect();
    }
    else
    {
        connect(serialConnection, SIGNAL(readyRead()), this, SLOT(readDataFromDevice()));
        emit statusChanged( CONNECTED );
        emit statusUpdated( tr("Connected successfully to port '%1'!").arg(port) );
    }
}

void SerialConnection::sendText(const QString& text)
{
    if( serialConnection == NULL )
    {
        emit errorOccurred( tr("Cannot send text without connection!") );
    }
    else
    {
        serialConnection->write(text.toLatin1());
    }
}

void SerialConnection::disconnect()
{
    qDebug() << "disconnect()";
    if( serialConnection == NULL )
    {
        emit errorOccurred( tr("Cannot disconnect non-existing connection!") );
    }
    else
    {
        serialConnection->close();
        emit statusUpdated( tr("Closed port '%1'!").arg(serialConnection->portName()) );
        emit statusChanged( DISCONNECTED );

        delete serialConnection;
        serialConnection = NULL;
    }
}

void SerialConnection::readDataFromDevice()
{
    if( serialConnection != NULL )
    {
        const QByteArray data = serialConnection->readAll();
        if( !data.isEmpty() ) emit dataReceived( data );
    }
    else
    {
        qWarning() << "readDataFromDevice on NULL!";
    }
}

void SerialConnection::handleError(QSerialPort::SerialPortError error)
{
    switch( error )
    {
    case QSerialPort::NoError: emit errorOccurred( tr("handleError emitted 'no error'") ); break;
    case QSerialPort::DeviceNotFoundError: emit errorOccurred( tr("Device not found!") ); break;
    case QSerialPort::PermissionError: emit errorOccurred( tr("Permission error!") ); break;
    case QSerialPort::OpenError: emit errorOccurred( tr("Open error!") ); break;
    case QSerialPort::ParityError: emit errorOccurred( tr("Parity error!") ); break;
    case QSerialPort::FramingError: emit errorOccurred( tr("Framing error!") ); break;
    case QSerialPort::BreakConditionError: emit errorOccurred( tr("Break condition error!") ); break;
    case QSerialPort::WriteError: emit errorOccurred( tr("Write error!") ); break;
    case QSerialPort::ReadError: emit errorOccurred( tr("Read error!") ); break;
    case QSerialPort::ResourceError: emit errorOccurred( tr("Resource error!") ); break;
    case QSerialPort::UnsupportedOperationError: emit errorOccurred( tr("Unsupported operation error!") ); break;
    case QSerialPort::UnknownError: emit errorOccurred( tr("Unknown error!") ); break;
    case QSerialPort::TimeoutError: emit errorOccurred( tr("Timeout error!") ); break;
    case QSerialPort::NotOpenError: emit errorOccurred( tr("Not open error!") ); break;
    }
}

int SerialConnection::convertToBaudRate( const QString& baudRate )
{
    bool bSuccessful;
    const int baudRateNb = baudRate.toInt(&bSuccessful);
    if( !bSuccessful )
    {
        emit errorOccurred( tr("Failed to convert baud-rate '%1' to integer!").arg(baudRate) );
        return 115200;
    }
    return baudRateNb;
}

QSerialPort::DataBits SerialConnection::convertToDataBits( int dataBits )
{
    switch( dataBits )
    {
    case 5: return QSerialPort::Data5;
    case 6: return QSerialPort::Data6;
    case 7: return QSerialPort::Data7;
    case 8: return QSerialPort::Data8;
    }

    emit errorOccurred( tr("Cannot handle data-bits value '%1'!").arg(dataBits) );
    return QSerialPort::Data8;
}

QSerialPort::Parity SerialConnection::convertToParity( const QString& parity )
{
    const QString lowerParity = parity.toLower();
    if(      lowerParity == "none"  ) return QSerialPort::NoParity;
    else if( lowerParity == "even"  ) return QSerialPort::EvenParity;
    else if( lowerParity == "odd"   ) return QSerialPort::OddParity;
    else if( lowerParity == "space" ) return QSerialPort::SpaceParity;
    else if( lowerParity == "mark"  ) return QSerialPort::MarkParity;

    emit errorOccurred( tr("Cannot handle parity value '%1'!").arg(parity) );
    return QSerialPort::NoParity;
}

void SerialConnection::setTransferData( const QString& dataPath )
{
    if( !dataPath.isEmpty() )
    {
        QFileInfo oFileInfo(dataPath.startsWith("file://") ? dataPath.mid(7) : dataPath);
        if( !oFileInfo.exists() )
        {
            emit errorOccurred( tr("Cannot find file at '%1'!").arg(oFileInfo.canonicalFilePath()) );
        }
    }
    else
    {
        emit errorOccurred( tr("No transfer data set!") );
    }
}

void SerialConnection::setCrc( const QString& crc )
{
    Q_UNUSED(crc);
}

void SerialConnection::setTrigger( const QString& trigger )
{
    Q_UNUSED(trigger);
}

void SerialConnection::setAnswer( const QString& answer )
{
    Q_UNUSED(answer);
}
