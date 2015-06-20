#include "ComPortModel.h"
#include <QSerialPortInfo>

ComPortModel::ComPortModel()
{
}

ComPortModel::~ComPortModel()
{
}

void ComPortModel::updateItems()
{
    QStringList newItemList;
    const QList<QSerialPortInfo> serialPorts = QSerialPortInfo::availablePorts();
    for( const QSerialPortInfo& serialPort : serialPorts )
    {
        newItemList << serialPort.portName();
    }
    setItems( newItemList );
}
