import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1
import UartFlasher.SerialConnection 1.0
import "elements" as Elements

ApplicationWindow {
    id: rootWindow
    title: qsTr("Uart Flasher")
    width:  600
    height: 350

    //
    // Signals
    //
    signal comPortModelUpdateRequested()
    signal sendRequested(string text)
    signal connectRequested(string dataPath, string port, string baudRate, int dataBits,
                            string parity, string crc, string trigger, string answer)
    signal disconnectRequested()

    //
    // Functions
    //
    function performConnectRequest() {
        connectRequested(transferDataGroup.transferDataUrl, settingsGroup.comPort, settingsGroup.baudRate, settingsGroup.dataBits,
                         settingsGroup.parity, settingsGroup.crc, settingsGroup.trigger, settingsGroup.answer);
    }

    //
    // Events
    //
    Component.onCompleted: {
        x = (Screen.width  - rootWindow.width ) / 2
        y = (Screen.height - rootWindow.height) / 2

        settingsGroup.comPortModelUpdateRequested.connect(comPortModelUpdateRequested)
        transferDataGroup.connectRequested.connect(performConnectRequest)
        transferDataGroup.disconnectRequested.connect(disconnectRequested)
        asciiProtocol.sendRequested.connect(sendRequested);

        visible = true
    }

    //
    // Connections
    //
    Connections {
        target: serialConnection
        onDataReceived: {
            asciiProtocol.appendText( data );
        }
        onErrorOccurred: {
            asciiProtocol.appendLine( qsTr("ERROR: ") + data );
        }
        onStatusUpdated: {
            asciiProtocol.appendLine( qsTr("STATUS: ") + data );
        }
        onStatusChanged: {
            switch( status )
            {
            case SerialConnection.UNKNOWN:
                asciiProtocol.appendLine( qsTr("ERROR: Received unknown status!") );
                status.text = qsTr( "ERROR" )
                break;
            case SerialConnection.DISCONNECTED:
                settingsGroup.enableItems();
                transferDataGroup.enableItems();

                transferDataGroup.setButtonText( qsTr("Connect") );
                status.text = qsTr( "DISCONNECTED" )
                break;

            case SerialConnection.CONNECTED:
                settingsGroup.disableItems();
                transferDataGroup.disableItems();

                transferDataGroup.setButtonText( qsTr("Disconnect") );
                status.text = qsTr( "CONNECTED" )
                break;
            }
        }
    }

    //
    // Elements
    //
    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }
    RowLayout {
        anchors.fill: parent
        anchors.margins: 15
        anchors.bottomMargin: 5

        ColumnLayout {
            Layout.alignment: Qt.AlignTop

            Elements.Settings {
                id: settingsGroup
                Layout.fillWidth: true
            }
            Elements.TransferData {
                id: transferDataGroup
                Layout.fillWidth: true
            }
        }
        Elements.Protocol {
            id: asciiProtocol
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }
    statusBar: StatusBar {
        RowLayout {
            Label {
                id: status
            }
        }
    }
}
