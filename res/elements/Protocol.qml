import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1


GroupBox {
    title: qsTr( "Protocol" )

    //
    // Signals
    //
    signal sendRequested( string text )

    //
    // Functions
    //
    function appendLine( line )
    {
        protocolField.append( line )
        protocolField.cursorPosition = protocolField.length
    }
    function appendText( text )
    {
        protocolField.insert( protocolField.length, text )
        protocolField.cursorPosition = protocolField.length
    }

    //
    // Elements
    //
    ColumnLayout {
        anchors.fill: parent
        TextArea {
            id: protocolField
            anchors.margins: 0
            implicitWidth: 400
            readOnly: true
            font.family: "courier new"
            font.pixelSize: 13
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
        RowLayout {
            TextField {
                id: sendTextField
                Layout.fillWidth: true
                onEditingFinished: {
                    sendRequested( sendTextField.text + "\n" )
                    sendTextField.text = ""
                }
            }
            Button {
                id: sendButton
                text: qsTr( "↵" )
                Layout.preferredWidth: 30
                onClicked: {
                    sendRequested( sendTextField.text + "\n" )
                    sendTextField.text = ""
                }
            }
        }
    }
}
