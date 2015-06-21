import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1


RowLayout {
    spacing: 0

    //
    // Functions
    //
    function append( text )
    {
        textArea.append( text )
    }
    function insertAtEnd( text )
    {
        textArea.insert( textArea.length, text )
    }
    function scrollToEnd()
    {
        textArea.cursorPosition = textArea.length
    }

    //
    // Elements
    //
    Rectangle {
        clip: true
        id: lineColumn
        Layout.fillHeight: true
        color: "#f2f2f2"
        width: 35
        property int rowHeight: textArea.font.pixelSize + 3
        Rectangle {
            anchors.right: parent.right
            width: 1
            color: "#ddd"
        }
        Column {
            y: -textArea.flickableItem.contentY + 4
            width: parent.width
            Repeater {
                model: Math.max(textArea.lineCount, (lineColumn.height/lineColumn.rowHeight) )
                delegate: Text {
                    id: text
                    color: "#666"
                    font: textArea.font
                    width: lineColumn.width
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    height: lineColumn.rowHeight
                    renderType: Text.NativeRendering
                    text: index
                }
            }
        }
    }
    TextArea {
        id: textArea
        textColor: "#3d3d3d"
        Layout.fillWidth: true
        Layout.fillHeight: true
        frameVisible: false
        wrapMode: TextEdit.NoWrap
        readOnly: true
//        font.family: "courier new"
//        font.pixelSize: 13
    }
}
