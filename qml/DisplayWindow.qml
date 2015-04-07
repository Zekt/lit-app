import QtQuick 2.0
import QtQuick.Window 2.1

Window {
    id: window
    title: "Lit"
    visible: true

    Text {
        id: label
        anchors.fill: parent
        horizontalAlignment: TextEdit.AlignHCenter
        verticalAlignment: TextEdit.AlignVCenter

        lineHeight: 1.15
        wrapMode: Text.NoWrap

        color: "#222"

        font.family: "Noto Sans T Chinese"
        font.weight: Font.DemiBold
        renderType: TextEdit.NativeRendering
        smooth: true

        Behavior on font.pixelSize {
            SmoothedAnimation {
                duration: 50
                easing.type: Easing.InExpo
            }
        }
    }

    Text {
        id: measurer
        opacity: 0
        renderType: Text.NativeRendering

        width: label.width
        horizontalAlignment: label.horizontalAlignment
        lineHeight: label.lineHeight
        wrapMode: label.wrapMode
        font: label.font
        text: label.text
    }

    Timer {
        id: timer
        interval: 50
        repeat: false
        running: false
        triggeredOnStart: false

        onTriggered: {
            var baseSize = Math.min(window.width, window.height)
            var ratio = 1.125

            do {
                measurer.font.pixelSize = baseSize
                baseSize = Math.floor(baseSize / ratio)
            } while (measurer.paintedWidth >= window.width ||
                     measurer.paintedHeight >= window.height)

            label.font.pixelSize = baseSize;
        }
    }

    Connections {
        target: app
        onTextChanged: {
            label.text = app.text
            timer.start()
        }
    }

    onWidthChanged: timer.start()
    onHeightChanged: timer.start()
    Component.onCompleted: {
        window.flags |= Qt.WindowDoesNotAcceptFocus
    }
}
