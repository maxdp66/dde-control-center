import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import "../widgets/"
import DBus.Com.Deepin.Daemon.DateAndTime 1.0
import "calendar_core.js" as CalendarCore

Item {
    id: dateTimeModule
    anchors.fill: parent

    property string timeFont: "Maven Pro Light"
    property var gDate: DateAndTime {}
    property var dconstants: DConstants {}
    property string lang: 'en'
    property var locale: Qt.locale()

    property var globalDate: new Date()
    property var weekNames: [dsTr("Sunday"), dsTr("Monday"), dsTr("Tuesday"), 
        dsTr("Wednesday"), dsTr("Thursday"), dsTr("Friday"), dsTr("Saturday"), 
        dsTr("Sunday")]
    
    Component.onCompleted: {
        lang = dsslocale.lang
    }

    Timer {
        running: true
        repeat: true
        interval: 500
        onTriggered: { 
            parent.globalDate= new Date()
            lang = dsslocale.lang
            dynamicTime.secondColonDisplay = !dynamicTime.secondColonDisplay
            Date.timeZoneUpdated()
        }
    }

    Column {
        id: contentColumn
        anchors.top: parent.top
        width: parent.width

        DssTitle { text: dsTr("Date & Time") }

        DSeparatorHorizontal {}

        Rectangle {
            id: timeBox
            width: parent.width
            height: 118
            color: "#1a1b1b"

            DigitalTime {
                id: dynamicTime
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 24
                use24Hour: twentyFourHourSetBox.active
            }

            Text {
                id: amPmText
                anchors.left: dynamicTime.right
                anchors.bottom: dynamicTime.bottom
                anchors.bottomMargin: -2
                color: "#666666"

                font.pixelSize: 14
                font.family: timeFont
                visible: !twentyFourHourSetBox.active
                text: globalDate.getHours() < 12 ? "AM" : "PM"
            }

            DLabel {
                id: dayText
                anchors.top: dynamicTime.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: dynamicTime.horizontalCenter

                font.pixelSize: 12
                text: globalDate.toLocaleDateString(locale)
            }

        }

        DSeparatorHorizontal {}

        DSwitchButtonHeader {
            id: autoSetTimeBox
            text: dsTr("Auto-sync datetime")
            width: parent.width
            active: gDate.autoSetTime

            onClicked: {
                gDate.SetAutoSetTime(active)
            }
        }

        DSeparatorHorizontal {}

        DSwitchButtonHeader {
            id: twentyFourHourSetBox
            text: dsTr("24 Hour")
            active: gDate.use24HourDisplay

            onClicked: {
                gDate.use24HourDisplay = active
            }
        }

        DSeparatorHorizontal {}

        DBaseExpand {
            id: timezoneExpand
            property int currentIndex: -1
            property string currentTimezoneLabel

            header.sourceComponent: DDownArrowHeader {
                text: dsTr("Timezone")
                hintText: timezoneExpand.currentTimezoneLabel
                onClicked: {
                    timezoneExpand.expanded = !timezoneExpand.expanded
                }
            }
            content.sourceComponent: Rectangle {
                id: timezoneList
                width: parent.width
                height: 200
                clip: true
                color: dconstants.contentBgColor

                TimezoneData { 
                    id: timezoneData 
                }

                ListView {
                    id: timezone_listview
                    anchors.fill: parent

                    model: timezoneData.timezoneList
                    delegate: TimezoneItem {}
                    focus: true
                    currentIndex: timezoneExpand.currentIndex

                    property int currentTimezoneValue: -1
                    
                    onCurrentTimezoneValueChanged: {
                        if (currentTimezoneValue != -1){
                            timezoneExpand.currentTimezoneLabel = currentItem.timezoneText
                            gDate.SetTimeZone(timezoneData.getTimezoneByOffset(currentTimezoneValue))
                        }
                    }
                }

                DScrollBar {
                    flickable: timezone_listview
                }
            }
        }

        DBaseLine {
            id: dateBoxTitle
            width: parent.width
            height: 38

            leftLoader.sourceComponent: DLabel {
                font.pixelSize: 13
                text: dsTr("Date")
            }

            rightLoader.sourceComponent: DTextButton {
                text: dsTr("Change Date")
                onClicked: {
                    print(calendarObj.cur_calendar.clickedDateObject)
                }
            }
        }

        DSeparatorHorizontal {}

        Calendar { id: calendarObj }
    }
}
