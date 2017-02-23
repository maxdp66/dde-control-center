#include "basiclistview.h"

#include <QDebug>

namespace dcc {

namespace widgets {

BasicListView::BasicListView(QWidget *parent)
    : QListView(parent),

      m_autoFitHeight(true)
{
//    setStyleSheet("background-color: red;");
    setFrameStyle(QFrame::NoFrame);
    setMouseTracking(true);
    setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
    setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
    setVerticalScrollMode(ScrollPerPixel);
    setContentsMargins(0, 0, 0, 0);
    setSpacing(0);
    setSelectionMode(NoSelection);
}

QSize BasicListView::sizeHint() const
{
    int height = 0;
    const int count = model()->rowCount();
    for (int i(0); i != count; ++i)
        height += sizeHintForRow(i);

    return QSize(QListView::sizeHint().width(), height);
}

void BasicListView::setModel(QAbstractItemModel *model)
{
    QListView::setModel(model);

    connect(model, &QAbstractItemModel::layoutChanged, this, &BasicListView::onContentHeightChanged, Qt::QueuedConnection);
    connect(model, &QAbstractItemModel::rowsInserted, this, &BasicListView::onContentHeightChanged, Qt::QueuedConnection);
    connect(model, &QAbstractItemModel::rowsRemoved, this, &BasicListView::onContentHeightChanged, Qt::QueuedConnection);
    onContentHeightChanged();
}

void BasicListView::onContentHeightChanged()
{
    if (!m_autoFitHeight)
        return;

    const int h = sizeHint().height();
    if (height() != h)
        setMaximumHeight(sizeHint().height());
}

void BasicListView::leaveEvent(QEvent *e)
{
    QListView::leaveEvent(e);

    emit entered(QModelIndex());
}

void BasicListView::setAutoFitHeight(const bool fit)
{
    m_autoFitHeight = fit;

    if (fit)
        onContentHeightChanged();
}

}

}
