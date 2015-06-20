#ifndef COMPORTMODEL_H
#define COMPORTMODEL_H

#include "StringListModel.h"

class ComPortModel : public StringListModel
{
    Q_OBJECT
public:
    ComPortModel();
    virtual ~ComPortModel();

public slots:
    void updateItems();
};

#endif // COMPORTMODEL_H
