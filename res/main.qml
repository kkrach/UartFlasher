import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.1

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

    MessageDialog {
        id: dataMissingDialog
        title: qsTr( "Transfer-data Missing" )
        text: qsTr( "Please load first the transfer-data!" )
    }

    statusBar: StatusBar {
    RowLayout {
        Label {
            id: status
            }
        }
    }

    signal comPortModelUpdateRequested()
    signal transferStartRequested(string dataPath, string port, string baudRate, int dataBits,
                                  string parity, string crc, string trigger, string answer)



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
                        enabled: false
                        value: 8
                        decimals: 0
                    }

                    Text {
                        text: qsTr("Parity:")
                    }
                    ComboBox {
                        id: parityCombo
                        Layout.fillWidth: true
                        enabled: false
                        model: [ "none" ]
                    }
                    Text {
                        text: qsTr("CRC:")
                    }
                    ComboBox {
                        id: crcCombo
                        Layout.fillWidth: true
                        enabled: false
                        model: [ "XOR" ]
                    }
                    Text {
                        text: qsTr("Trigger:")
                    }
                    ComboBox {
                        id: triggerCombo
                        Layout.fillWidth: true
                        enabled: false
                        model: [ "Start TX" ]
                    }
                    Text {
                        text: qsTr("Answer:")
                    }
                    ComboBox {
                        id: answerCombo
                        Layout.fillWidth: true
                        enabled: false
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
                            text: qsTr( "Load" )
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
                            text: qsTr( "Transfer" )
                            onClicked: {
                                if( transferDataUrl.length == 0 )
                                {
                                    dataMissingDialog.open()
                                }
                                else
                                {
                                    transferStartRequested(transferDataUrl.text, comPortCombo.currentText,
                                                           baudRateCombo.currentText, dataBitesSpinbox.value,
                                                           parityCombo.currentText, crcCombo.currentText,
                                                           triggerCombo.currentText, answerCombo.currentText)
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
                protocolField.append( "" + data )
                protocolField.cursorPosition = protocolField.length
            }
            onErrorOccurred: {
                protocolField.append( "ERROR: " + data )
                protocolField.cursorPosition = protocolField.length
            }
            onStatusUpdated: {
                protocolField.append( "STATUS: " + data )
                protocolField.cursorPosition = protocolField.length
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
                        Layout.fillWidth: true
                    }
                    Button {
                        id: sendButton
                        text: qsTr( "↵" )
                        Layout.preferredWidth: 30
                        onClicked: {
                            protocolField.append( "$ " + "haha" )
                            protocolField.cursorPosition = protocolField.length
                        }
                    }
                }
            }
        }
    }
}
