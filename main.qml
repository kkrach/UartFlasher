import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

ApplicationWindow {
    visible: true
    width:  200     // using too small values, to get minimum window size
    height: 200     // using too small values, to get minimum window size
    title: qsTr("Uart Flasher")

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
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

    function updateComPortCombo() {
        comPortModelUpdateRequested();
        console.log( "updateComPortCombo" )
    }


    RowLayout {
        id: rootLayout
        anchors.fill: parent
        anchors.margins: 10

        ColumnLayout {
            Layout.alignment: Qt.AlignTop
            Layout.fillHeight: true
            Layout.fillWidth: true
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
                            onClicked: updateComPortCombo()
                        }
                    }
                    Text {
                        text: qsTr("Baud Rate:")
                    }
                    ComboBox {
                        Layout.fillWidth: true
                        model: [ "115.2", "57.6", "9.6" ]
                    }
                    Text {
                        text: qsTr("Data Bits:")
                    }
                    SpinBox {
                        Layout.fillWidth: true
                        enabled: false
                        value: 8
                        decimals: 0
                    }

                    Text {
                        text: qsTr("Parity:")
                    }
                    ComboBox {
                        Layout.fillWidth: true
                        enabled: false
                        model: [ "none" ]
                    }
                    Text {
                        text: qsTr("CRC:")
                    }
                    ComboBox {
                        Layout.fillWidth: true
                        enabled: false
                        model: [ "XOR" ]
                    }
                    Text {
                        text: qsTr("Trigger:")
                    }
                    ComboBox {
                        Layout.fillWidth: true
                        enabled: false
                        model: [ "Start TX" ]
                    }
                    Text {
                        text: qsTr("Answer:")
                    }
                    ComboBox {
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
                            enabled: false
                            Layout.fillWidth: true
                        }
                        Button {
                            text: qsTr( "Load" )
                        }
                    }
                    RowLayout {
                        Layout.alignment: Qt.AlignRight
                        Button {
                            text: qsTr( "Transfer" )
                        }
                    }
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
                    readOnly: true
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
                    }
                }
            }
        }
    }
}
