#include "StringListModel.h"

StringListModel::StringListModel()
{
}

StringListModel::~StringListModel()
{
}

void StringListModel::setItems( QStringList items )
{
    qSort( items );
    if( items != comboItems )
    {
        comboItems = items;
        emit itemsChanged();
    }
}
