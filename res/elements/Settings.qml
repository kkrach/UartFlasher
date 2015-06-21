import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

GroupBox {
    title: qsTr( "Settings" )

    //
    // Properties / Variables
    //
    property alias comPort: comPortCombo.currentText
    property alias baudRate: baudRateCombo.currentText
    property alias dataBits: dataBitsSpinbox.value
    property alias parity: parityCombo.currentText
    property alias crc: crcCombo.currentText
    property alias trigger: triggerCombo.currentText
    property alias answer: answerCombo.currentText

    //
    // Signals
    //
    signal comPortModelUpdateRequested()

    //
    // Functions
    //
    function enableItems() {
        comPortCombo.enabled = true
        reloadButton.enabled = true
        baudRateCombo.enabled = true
        dataBitsSpinbox.enabled = true
        parityCombo.enabled = true
        crcCombo.enabled = true
        triggerCombo.enabled = true
        answerCombo.enabled = true
    }
    function disableItems() {
        comPortCombo.enabled = false
        reloadButton.enabled = false
        baudRateCombo.enabled = false
        dataBitsSpinbox.enabled = false
        parityCombo.enabled = false
        crcCombo.enabled = false
        triggerCombo.enabled = false
        answerCombo.enabled = false
    }

    //
    // Elements
    //
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
            id: dataBitsSpinbox
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

