#ifndef StringListModel_H
#define StringListModel_H

#include <QObject>
#include <QStringList>

class StringListModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList items READ items WRITE setItems NOTIFY itemsChanged)

public:
    StringListModel();
    virtual ~StringListModel();
    const QStringList items() const { return comboItems; }

public slots:
    void setItems( QStringList items );

signals:
    void itemsChanged();

private:
    QStringList comboItems;
};

#endif // StringListModel_H
