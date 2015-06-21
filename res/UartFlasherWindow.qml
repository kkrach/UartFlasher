import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.1
import UartFlasher.SerialConnection 1.0

ApplicationWindow {
    id: rootWindow
    visible: true
    width:  600
    height: 350
    title: qsTr("Uart Flasher")


    Component.onCompleted: {
        x = (Screen.width  - rootWindow.width ) / 2
        y = (Screen.height - rootWindow.height) / 2
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: qsTr( "Please choose a file" )
        visible: false
        signal dialogAccepted();
        signal dialogRejected();
        onAccepted: {
            dialogAccepted()
            visible = false
        }
        onRejected: {
            dialogRejected()
            visible = false
        }
    }

    statusBar: StatusBar {
    RowLayout {
        Label {
            id: status
            }
        }
    }

    signal comPortModelUpdateRequested()
    signal sendRequested(string text)
    signal connectRequested(string dataPath, string port, string baudRate, int dataBits,
                            string parity, string crc, string trigger, string answer)
    signal disconnectRequested()



    RowLayout {
        id: rootLayout
        anchors.fill: parent
        anchors.margins: 15
        anchors.bottomMargin: 5

        ColumnLayout {
            Layout.alignment: Qt.AlignTop
            GroupBox {
                title: qsTr( "Settings" )
                Layout.fillWidth: true

                GridLayout {
                    anchors.fill: parent
                    columns: 2
                    Text {
                        text: qsTr("Serial Port:")
                    }
                    RowLayout {
                        ComboBox {
                            id: comPortCombo
                            Layout.fillWidth: true
                            model: comPortModel.items;
                        }
                        Button {
                            id: reloadButton
                            Layout.maximumWidth: 30
                            text: qsTr( "↻" )
                            onClicked: comPortModelUpdateRequested()
                        }
                    }
                    Text {
                        text: qsTr("Baud Rate:")
                    }
                    ComboBox {
                        id: baudRateCombo
                        Layout.fillWidth: true
                        model: [ "115200", "57600", "9600" ]
                        currentIndex: 1
                    }
                    Text {
                        text: qsTr("Data Bits:")
                    }
                    SpinBox {
                        id: dataBitesSpinbox
                        Layout.fillWidth: true
                        value: 8
                        decimals: 0
                    }

                    Text {
                        text: qsTr("Parity:")
                    }
                    ComboBox {
                        id: parityCombo
                        Layout.fillWidth: true
                        model: [ "none" ]
                    }
                    Text {
                        text: qsTr("CRC:")
                    }
                    ComboBox {
                        id: crcCombo
                        Layout.fillWidth: true
                        model: [ "XOR" ]
                    }
                    Text {
                        text: qsTr("Trigger:")
                    }
                    ComboBox {
                        id: triggerCombo
                        Layout.fillWidth: true
                        model: [ "Start TX" ]
                    }
                    Text {
                        text: qsTr("Answer:")
                    }
                    ComboBox {
                        id: answerCombo
                        Layout.fillWidth: true
                        model: [ "Start of Header" ]
                    }
                }
            }

            GroupBox {
                title: qsTr( "Transfer Data" )
                Layout.fillWidth: true

                ColumnLayout {
                    anchors.fill: parent
                    RowLayout {
                        Layout.fillWidth: true
                        TextField {
                            id: transferDataUrl
                            Layout.fillWidth: true
                        }
                        Button {
                            id: loadButton
                            text: qsTr( "✎" )
                            Layout.maximumWidth: 30
                            onClicked: {
                                fileDialog.open()
                                fileDialog.dialogAccepted.connect(getUrlFromDialog);
                            }
                            function getUrlFromDialog() {
                                transferDataUrl.text = fileDialog.fileUrl
                            }
                        }
                    }
                    RowLayout {
                        Layout.alignment: Qt.AlignRight
                        Button {
                            id: connectButton
                            text: qsTr( "Connect" )
                            onClicked: {
                                if( text === qsTr("Connect") ) {
                                    connectRequested(transferDataUrl.text, comPortCombo.currentText,
                                                     baudRateCombo.currentText, dataBitesSpinbox.value,
                                                     parityCombo.currentText, crcCombo.currentText,
                                                     triggerCombo.currentText, answerCombo.currentText)
                                }
                                else {
                                    disconnectRequested()
                                }
                            }
                        }
                    }
                }
            }
        }


        Connections {
            target: serialConnection
            onDataReceived: {
                protocolField.insert( protocolField.length, data )
                //protocolField.append( "" + data )
                protocolField.cursorPosition = protocolField.length
            }
            onErrorOccurred: {
                protocolField.append( qsTr("ERROR: ") + data )
                protocolField.cursorPosition = protocolField.length
            }
            onStatusUpdated: {
                protocolField.append( qsTr("STATUS: ") + data )
                protocolField.cursorPosition = protocolField.length
            }
            onStatusChanged: {
                switch( status )
                {
                case SerialConnection.UNKNOWN:
                    console.error( qsTr("Received unknown status!") )
                    break;
                case SerialConnection.DISCONNECTED:
                    comPortCombo.enabled = true
                    reloadButton.enabled = true
                    baudRateCombo.enabled = true
                    dataBitesSpinbox.enabled = true
                    parityCombo.enabled = true
                    crcCombo.enabled = true
                    triggerCombo.enabled = true
                    answerCombo.enabled = true
                    transferDataUrl.enabled = true
                    loadButton.enabled = true
                    connectButton.text = qsTr( "Connect" )
                    status.text = ""
                    break;

                case SerialConnection.CONNECTED:
                    comPortCombo.enabled = false
                    reloadButton.enabled = false
                    baudRateCombo.enabled = false
                    dataBitesSpinbox.enabled = false
                    parityCombo.enabled = false
                    crcCombo.enabled = false
                    triggerCombo.enabled = false
                    answerCombo.enabled = false
                    transferDataUrl.enabled = false
                    loadButton.enabled = false
                    connectButton.text = qsTr( "Disconnect" )
                    status.text = qsTr( "CONNECTED" )
                    break;
                }
            }
        }

        GroupBox {
            title: qsTr( "Protocol" )
            Layout.fillHeight: true
            Layout.fillWidth: true

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
    }
}
