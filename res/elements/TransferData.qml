import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2


GroupBox {
    title: qsTr( "Transfer Data" )

    //
    // Properties / Variables
    //
    property alias transferDataUrl: transferDataUrlTextfield.text

    //
    // Signals
    //
    signal connectRequested()
    signal disconnectRequested()

    //
    // Functions
    //
    function enableItems() {
        transferDataUrlTextfield.enabled = true
        loadButton.enabled = true
    }
    function disableItems() {
        transferDataUrlTextfield.enabled = false
        loadButton.enabled = false
    }
    function setButtonText( text ) {
        connectButton.text = text
    }

    //
    // Dialogs
    //
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

    //
    // Elements
    //
    ColumnLayout {
        anchors.fill: parent
        RowLayout {
            Layout.fillWidth: true
            TextField {
                id: transferDataUrlTextfield
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
                    transferDataUrl = fileDialog.fileUrl
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
                        connectRequested()
                    }
                    else {
                        disconnectRequested()
                    }
                }
            }
        }
    }
}
