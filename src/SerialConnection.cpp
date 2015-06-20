#include "SerialConnection.h"
#include <QDebug>
#include <QFile>
#include <QFileInfo>
#include <QMessageBox>





SerialConnection::SerialConnection(QObject *parent) :
    QObject(parent)
{
}

void SerialConnection::setupConnection( const QString& dataPath, const QString& port, const QString& baudRate,
                                        int dataBits, const QString& parity, const QString& crc,
                                        const QString& trigger, const QString& answer )
{
    QFileInfo oFileInfo(dataPath.startsWith("file://") ? dataPath.mid(7) : dataPath);
    if( !oFileInfo.exists() )
    {
        const QString message = tr("Cannot find file at '%1'!").arg(oFileInfo.canonicalFilePath());
        errorOccurred(message);
        QMessageBox::critical( NULL, tr("Error"), message );
        return;
    }

    QSerialPort oSerialPort;
    oSerialPort.setPortName(port);
    oSerialPort.setBaudRate(convertToBaudRate(baudRate));
    oSerialPort.setDataBits(convertToDataBits(dataBits));
    oSerialPort.setParity(  convertToParity(parity));
    //oSerialPort.setStopBits();
    oSerialPort.setFlowControl(QSerialPort::HardwareControl);
    if( !oSerialPort.open(QSerialPort::ReadWrite) )
    {
        const QString message = tr("Failed to open serial port '%1'!").arg(port);
        errorOccurred(message);
        QMessageBox::critical( NULL, tr("Error"), message );
        return;
    }
    emit statusUpdated( tr("Connected successfully to port '%1'!").arg(port) );

    oSerialPort.close();
    emit statusUpdated( tr("Closed port '%1'!").arg(port) );
}

int SerialConnection::convertToBaudRate( const QString& baudRate )
{
    return baudRate.toInt();
}

QSerialPort::DataBits SerialConnection::convertToDataBits( int dataBits )
{
    return QSerialPort::Data8;
}

QSerialPort::Parity SerialConnection::convertToParity( const QString& parity )
{
    return QSerialPort::NoParity;
}
