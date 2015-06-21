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
        asciiProtocol.textArea.append( line )
        asciiProtocol.textArea.scrollToEnd();

        hexProtocol.textArea.append( line )
        hexProtocol.textArea.scrollToEnd();
    }
    function appendText( text )
    {
        asciiProtocol.textArea.insertAtEnd( text )
        //asciiProtocol.textArea.scrollToEnd();

        hexProtocol.textArea.insertAtEnd( convertToHex(text) )
        //hexProtocol.textArea.scrollToEnd();
    }
    function convertToHex( text )
    {
        var hexLine = ""
        for( var i = 0, len = text.length; i < len; i++ ) {
            var charCode = text.charCodeAt(i)
            if( charCode === 0x20 ) { // SPACE
                hexLine += " "
            }
            if( charCode === 0x0A ) { // NEW LINE
                hexLine += "↵\n"
            }
            if( charCode === 0x0D ) { // CARRIAGE RETURN
                hexLine += "←"
            }
            else {
                var hexCode = charCode.toString(16)
                for( var l=hexCode.length; l < 2; l++ )
                    hexCode = "0" + hexCode;
                hexLine += hexCode
            }
        }
        return hexLine.toUpperCase();
    }

    //
    // Elements
    //
    ColumnLayout {
        anchors.fill: parent
        TabView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Tab {
                id: asciiProtocol
                title: qsTr( "ASCII" )
                property Item textArea: item
                active: true


                ProtocolArea {
                    //id: hexField
                    implicitWidth: 400
                }
            }
            Tab {
                id: hexProtocol
                title: qsTr( "Hexadecimal" )
                property Item textArea: item
                active: true

                ProtocolArea {
                    //id: hexField
                    implicitWidth: 400
                }
            }
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
