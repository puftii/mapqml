import QtQuick 2.5
import QtQuick.Window 2.2
import QtLocation 5.9
import QtPositioning
import QtQuick.Controls 2.5

Window {
    visible: true
    width: 640
    height: 480

    Plugin {
         id: mapPlugin
         name: "osm"
         PluginParameter {
             name: "osm.mapping.host";
             value: "http://a.tile.openstreetmap.org/"
         }
    }


    Map {
           id: map
           anchors.fill: parent
           plugin: mapPlugin
           center: QtPositioning.coordinate(57.9131586, 59.9708613) // Oslo
           zoomLevel: 14
           property geoCoordinate startCentroid

           MouseArea{
               anchors.fill: parent

               property int lastX : -1
               property int lastY : -1
               onWheel:  {
                   // workaround for QTBUG-87646 / QTBUG-112394 / QTBUG-112432:
                   // Magic Mouse pretends to be a trackpad but doesn't work with PinchHandler
                   // and we don't yet distinguish mice and trackpads on Wayland either
                   map.zoomLevel = map.zoomLevel + wheel.angleDelta.y/120

               }
               onPressed : {
                   lastX = mouse.x
                   lastY = mouse.y
               }

               onPositionChanged: {
                   map.pan(lastX-mouse.x, lastY-mouse.y)
                   lastX = mouse.x
                   lastY = mouse.y
               }
               onClicked:  lineEdit.text = ""+ map.toCoordinate(Qt.point(mouse.x,mouse.y))


           }

       }



}
