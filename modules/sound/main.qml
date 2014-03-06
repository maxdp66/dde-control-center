import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import Deepin.Widgets 1.0
import DBus.Com.Deepin.Daemon.Audio 1.0
import "../shared/"

Item {
    id: soundModule
    anchors.fill: parent

    property int contentLeftMargin: 22
    property int lineHeight: 30
    property int contentHeight: 60
    property int sliderWidth: 170
    property int leftWidth: 100
    property color titleColor: "#ffffff"
    property int itemLabelLeftMargin: 22

    property var audioId: Audio {}
    property var listModelComponent: DListModelComponent {}

    Component {
        id: sinkComponent
        AudioSink {}
    }

    Component {
        id: sourceComponent
        AudioSource {}
    }

    property var allSources: {
        var sourceList = new Array()
        var sourcePaths = audioId.GetSources()
        for(var i=0; i<sourcePaths.length; i++){
            var sourceObj = sourceComponent.createObject(soundModule, { path: sourcePaths[i] })
            sourceList.push(sourceObj)
        }
        return sourceList
    }

    property var allSinks: {
        var sinkList = new Array()
        var sinkPaths = audioId.GetSinks()
        for(var i=0; i<sinkPaths.length; i++){
            var sinkObj = sinkComponent.createObject(soundModule, { path: sinkPaths[i] })
            sinkList.push(sinkObj)
        }
        return sinkList
    }

    property var currentSink: allSinks[audioId.defaultSink]
    property var currentSource: allSources[audioId.defaultSource]

    Component.onCompleted: {
        if (dsslocale.lang == "zh") {
            leftWidth = 80
        }
    }

    Column {
        id: titleColumn
        width: parent.width
        height: childrenRect.height
        z: 1

        DssTitle {
            text: dsTr("Sound")
        }

        DSeparatorHorizontal{}
    }

    Flickable {
        anchors.top: titleColumn.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        contentWidth: parent.width
        contentHeight: normalSettings.height + advancedSettings.height + link_button_column.height

        Column {
            id: normalSettings
            width: parent.width
            height: myRealHeight
            x: 0
            /* y: link_button_column.isAdvanced ? titleColumn.height - myRealHeight : titleColumn.height */
            property int myRealHeight: childrenRect.height
            clip: true

            Behavior on y{
                PropertyAnimation {duration: 200}
            }

            DBaseLine{height: 8}
            DBaseLine {
                leftLoader.sourceComponent: DssH2 {
                    text: dsTr("Speaker")
                    color: titleColor
                }

                rightLoader.sourceComponent: Component{
                    DSwitchButton {
                        checked: !currentSink.mute
                        onClicked: {
                            currentSink.mute = !checked
                        }
                    }
                }
            }

            Column {
                id: outputColumn
                width: parent.width
                height: currentSink.mute ? 0 : childrenRect.height
                clip: true

                Behavior on height {
                    NumberAnimation { duration: 100 }
                }

                DSeparatorHorizontal {}

                DBaseLine {
                    height: contentHeight
                    leftMargin: contentLeftMargin
                    leftLoader.sourceComponent: LeftTitle {
                        text: dsTr("Output Volume")
                    }
                    rightLoader.sourceComponent: DSliderRect {
                        width: sliderWidth
                        leftLabel: dsTr("-")
                        rightLabel: dsTr("+")

                        value: currentSink.volume/100
                        onValueChanged: {
                            currentSink.volume = parseInt(value * 100)
                        }
                    }
                }

                DBaseLine {
                    height: contentHeight
                    leftMargin: contentLeftMargin
                    leftLoader.sourceComponent: LeftTitle {
                        text: dsTr("Balance")
                    }
                    rightLoader.sourceComponent: DSliderRect {
                        width: sliderWidth
                        leftLabel: dsTr("Left")
                        rightLabel: dsTr("Right")

                        value: (currentSink.balance+1)/2
                        onValueChanged: {
                            currentSink.balance = value * 2 - 1
                        }
                    }
                }
            }

            DSeparatorHorizontal {}

            DBaseLine {}
            DBaseLine {
                leftLoader.sourceComponent: DssH2 {
                    text: dsTr("Microphone")
                    color: titleColor
                }

                rightLoader.sourceComponent: Component{
                    DSwitchButton {
                        checked: !currentSource.mute
                        onClicked: {
                            currentSource.mute = !checked
                        }
                    }
                }
            }

            DSeparatorHorizontal {}

            Column {
                id: inputColumn
                width: parent.width
                height: currentSource.mute ? 0 : childrenRect.height

                Behavior on height {
                    NumberAnimation { duration: 100 }
                }


                DBaseLine {
                    height: contentHeight
                    leftMargin: contentLeftMargin
                    leftLoader.sourceComponent: LeftTitle {
                        text: dsTr("Input Volume")
                    }
                    rightLoader.sourceComponent: DSliderRect {
                        width: sliderWidth
                        leftLabel: dsTr("-")
                        rightLabel: dsTr("+")

                        value: currentSource.volume/100
                        onValueChanged: {
                            currentSource.volume = parseInt(value * 100)
                        }
                    }
                }

                DBaseLine {
                    height: contentHeight
                    leftMargin: contentLeftMargin
                    leftLoader.sourceComponent: LeftTitle {
                        text: dsTr("Input Level")
                    }
                    rightLoader.sourceComponent: DSliderRect {
                        width: sliderWidth

                        value: (currentSource.balance+1)/2
                        onValueChanged: {
                            currentSource.balance = value * 2 - 1
                        }
                    }
                }

                DSeparatorHorizontal {}
            }
        }

        Column {
            id: advancedSettings
            width: parent.width
            height: link_button_column.isAdvanced ? myRealHeight : 0
            anchors.top: normalSettings.bottom
            clip: true

            property int myRealHeight: childrenRect.height

            Behavior on height {
                PropertyAnimation {duration: 200}
            }

            DBaseLine{}
            DBaseLine{
                leftLoader.sourceComponent: DssH2 {
                    text: dsTr("Output Port")
                    color: titleColor
                }
            }

            DSeparatorHorizontal {}

            Rectangle {
                width: parent.width
                height: childrenRect.height
                color: dconstants.contentBgColor

                DBaseLine{
                    visible: outputPortList.count == 0
                    color: dconstants.contentBgColor
                    leftMargin: itemLabelLeftMargin
                    leftLoader.sourceComponent: DssH3{
                        text: dsTr("No port exist in this device.")
                    }
                }

                ListView {
                    id: outputPortList
                    width: parent.width
                    height: childrenRect.height
                    visible: count != 0

                    property int selectItemId: currentSink.activePort

                    model: {
                        var outputPortListModel = listModelComponent.createObject(outputPortList, {})
                        var ports = currentSink.ports
                        for(var i=0; i<ports.length; i++){
                            outputPortListModel.append({
                                                           "item_id": i,
                                                           "item_name": ports[i][1]
                                                       })
                        }
                        return outputPortListModel
                    }

                    delegate: SelectItem {
                        labelLeftMargin: itemLabelLeftMargin
                        totalItemNumber: outputPortList.count
                        selectItemId: String(outputPortList.selectItemId)

                        onSelectAction: {
                            currentSink.SetSinkPort(itemId)
                        }
                    }
                } // End of outputPortList

            }

            DSeparatorHorizontal{}

            DBaseLine{
                leftLoader.sourceComponent: DssH2 {
                    text: dsTr("Output device")
                    color: titleColor
                }
            }

            DSeparatorHorizontal {}

            Rectangle {
                width: parent.width
                height: childrenRect.height
                color: dconstants.contentBgColor

                ListView{
                    id: outputDeviceList
                    width: parent.width
                    height: count * 28

                    property int selectItemId: audioId.defaultSink

                    model: {
                        var outputDeviceListModel = listModelComponent.createObject(outputDeviceList, {})
                        for(var i=0; i<allSinks.length; i++){
                            outputDeviceListModel.append({
                                                             "item_id": i,
                                                             "item_name": allSinks[i].description
                                                         })
                        }
                        return outputDeviceListModel
                    }

                    delegate: SelectItem{
                        labelLeftMargin: itemLabelLeftMargin
                        totalItemNumber: outputDeviceList.count
                        selectItemId: String(outputDeviceList.selectItemId)

                        onSelectAction: {
                            audioId.defaultSink = itemId
                        }
                    }
                } // End of inputDeviceList

            }


            DSeparatorHorizontal{}

            DBaseLine {}
            DBaseLine{
                leftLoader.sourceComponent: DssH2 {
                    text: dsTr("Input Port")
                    color: titleColor
                }
            }

            DSeparatorHorizontal {}

            Rectangle {
                width: parent.width
                height: childrenRect.height
                color: dconstants.contentBgColor

                DBaseLine{
                    visible: inputPortList.count == 0
                    color: dconstants.contentBgColor
                    leftMargin: itemLabelLeftMargin
                    leftLoader.sourceComponent: DssH3{
                        text: dsTr("No port exist in this device.")
                    }
                }

                ListView {
                    id: inputPortList
                    width: parent.width
                    height: childrenRect.height
                    visible: count != 0

                    property int selectItemId: currentSource.activePort

                    model: {
                        var inputPortListModel = listModelComponent.createObject(inputPortList, {})
                        var ports = currentSource.ports
                        for(var i=0; i<ports.length; i++){
                            inputPortListModel.append({
                                                          "item_id": i,
                                                          "item_name": ports[i][1]
                                                      })
                        }
                        return inputPortListModel
                    }

                    delegate: SelectItem {
                        labelLeftMargin: itemLabelLeftMargin
                        totalItemNumber: inputPortList.count
                        selectItemId: String(inputPortList.selectItemId)

                        onSelectAction: {
                            currentSource.SetSourcePort(itemId)
                        }
                    }
                } // End of outputPortList

            }

            DSeparatorHorizontal {}

            DBaseLine{
                leftLoader.sourceComponent: DssH2 {
                    text: dsTr("Input device")
                    color: titleColor
                }
            }
            DSeparatorHorizontal {}

            Rectangle {
                width: parent.width
                height: childrenRect.height
                color: dconstants.contentBgColor

                ListView{
                    id: inputDeviceList
                    width: parent.width
                    height: childrenRect.height

                    property int selectItemId: audioId.defaultSource

                    model: {
                        var inputDeviceListModel = listModelComponent.createObject(inputDeviceList, {})
                        for(var i=0; i<allSources.length; i++){
                            inputDeviceListModel.append({
                                                            "item_id": i,
                                                            "item_name": allSources[i].description
                                                        })
                        }
                        return inputDeviceListModel
                    }

                    delegate: SelectItem{
                        labelLeftMargin: itemLabelLeftMargin
                        totalItemNumber: inputDeviceList.count
                        selectItemId: String(inputDeviceList.selectItemId)

                        onSelectAction: {
                            audioId.defaultSource = itemId
                        }
                    }
                }
            }

            DSeparatorHorizontal {}
        }

        Column {
            id: link_button_column
            anchors.top: advancedSettings.bottom
            width: parent.width
            height: childrenRect.height
            property bool isAdvanced: false

            DBaseLine{
                rightLoader.sourceComponent: LinkButton {
                    id: link_button
                    text: link_button_column.isAdvanced ? dsTr("Hide Advanced...") : dsTr("Show Advanced...")
                    onClicked: {
                        link_button_column.isAdvanced = !link_button_column.isAdvanced
                    }
                }
            }
        }
    }
}
