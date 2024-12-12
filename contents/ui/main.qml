/*
 *    SPDX-FileCopyrightText: 2024 Your Name <your.email@example.com>
 *
 *    SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5 as QQC2
import org.kde.kirigami 2.20 as Kirigami
import org.kde.ksvg 1.0 as KSvg
import org.kde.plasma.plasma5support 2.0 as P5Support
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid

PlasmoidItem {
    id: main

    // Make the widget as compact as possible
    switchWidth: Kirigami.Units.gridUnit * 5
    switchHeight: Kirigami.Units.gridUnit * 2

    // Ensure the widget is always expanded (fully visible)
    expanded: true

    // Properties for the distraction counter
    property int distractionCount: 0
    property TextEdit display

    function incrementCount() {
        distractionCount++;
        updateDisplay();
    }

    function decrementCount() {
        if (distractionCount > 0) {
            distractionCount--;
        }
        updateDisplay();
    }

    function resetCount() {
        distractionCount = 0;
        updateDisplay();
    }

    function updateDisplay() {
        display.text = distractionCount.toString();
    }


    // This becomes the main representation, replacing fullRepresentation
    compactRepresentation: RowLayout {
        id: compactLayout
        
        PlasmaComponents.Label {
            id: countDisplay
            text: distractionCount.toString()
            font.pixelSize: Kirigami.Units.gridUnit
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter
        }

        PlasmaComponents.ToolButton {
            id: incrementButton
            text: "+"
            Layout.fillHeight: true
            onClicked: incrementCount()
        }

        PlasmaComponents.ToolButton {
            id: decrementButton
            text: "-"
            Layout.fillHeight: true
            onClicked: decrementCount()
        }

        PlasmaComponents.ToolButton {
            id: resetButton
            text: "R"
            Layout.fillHeight: true
            onClicked: resetCount()
        }
    }

    // Optional: keep a full representation for when more space is available
    fullRepresentation: QQC2.Control {
        font.pixelSize: Math.round(width / 12)
        padding: 0
        Layout.minimumWidth: main.switchWidth
        Layout.minimumHeight: main.switchHeight
        Layout.preferredWidth: main.switchWidth * 2
        Layout.preferredHeight: main.switchHeight * 2

        contentItem: ColumnLayout {
            id: mainLayout
            anchors.fill: parent
            anchors.margins: 4
            spacing: 4
            focus: true

            KSvg.FrameSvgItem {
                id: displayFrame
                Layout.fillWidth: true
                Layout.minimumHeight: 2 * display.font.pixelSize
                imagePath: "widgets/frame"
                prefix: "plain"

                TextEdit {
                    id: display
                    anchors {
                        fill: parent
                        margins: parent.margins.right
                    }
                    text: "0"
                    font.pointSize: Kirigami.Theme.defaultFont.pointSize * 2
                    font.weight: Font.Bold
                    Kirigami.Theme.colorSet: Kirigami.Theme.View
                    color: Kirigami.Theme.textColor
                    horizontalAlignment: TextEdit.AlignRight
                    verticalAlignment: TextEdit.AlignVCenter
                    readOnly: true
                    focus: main.expanded
                    Accessible.name: i18nc("@label result of distraction count", "Distraction Count")
                    Accessible.description: i18nc("@info description", "Displays the number of distractions recorded")
                }

                // Add this Binding
                Binding {
                    target: main
                    property: "display"
                    value: display
                }
            }

            GridLayout {
                id: buttonsGrid
                columns: 3
                rows: 1
                columnSpacing: 4
                rowSpacing: 4
                Layout.fillWidth: true

                PlasmaComponents.ToolButton {
                    id: decrementButton
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: "-"
                    Accessible.name: i18nc("@action:button", "Decrease Distraction Count")
                    Accessible.description: i18nc("@info:tooltip", "Decrease the distraction count by one")
                    onClicked: decrementCount()
                }

                PlasmaComponents.ToolButton {
                    id: incrementButton
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: "+"
                    Accessible.name: i18nc("@action:button", "Increase Distraction Count")
                    Accessible.description: i18nc("@info:tooltip", "Increase the distraction count by one")
                    onClicked: incrementCount()
                }

                PlasmaComponents.ToolButton {
                    id: resetButton
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: "Reset"
                    Accessible.name: i18nc("@action:button", "Reset Distraction Count")
                    Accessible.description: i18nc("@info:tooltip", "Reset the distraction count to zero")
                    onClicked: resetCount()
                }
            }

            // Call updateDisplay when the component is fully loaded
            Component.onCompleted: updateDisplay()
        }
    }
}