// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

import QtQuick 2.12
import QtQuick.Controls 2.15
import QtMultimedia 5.15




// Contenedor principal
Rectangle {
    id: multiMediaPlayer

    property bool mmIsLandScape

    width: parent.width
    height: parent.height
    color: "#1c1c1c"


    function millisecondsToTime(ms) {
        var hours = Math.floor(ms / 3600000); // Dividir por 3600000 para obtener las horas
        var minutes = Math.floor((ms % 3600000) / 60000); // Obtener los minutos restantes
        var seconds = Math.floor((ms % 60000) / 1000); // Obtener los segundos restantes
        var hourText = ""

        // Asegurarse de que las horas, minutos y segundos tengan dos dígitos
//        return (hours < 10 ? "0" + hours : hours) + ":" +
//               (minutes < 10 ? "0" + minutes : minutes) + ":" +
//               (seconds < 10 ? "0" + seconds : seconds);
        hourText = (hours) ? ((hours < 10 ? "0" + hours : hours) + ":") : ""
        return  hourText +
               (minutes < 10 ? "0" + minutes : minutes) + ":" +
               (seconds < 10 ? "0" + seconds : seconds);
    }



    // VideoOutput para mostrar el video
    VideoOutput {
        id: videoOutput
        anchors.fill: parent  // El video ocupa todo el área de la ventana
        source: player


    }

    // Video o Audio player
    MediaPlayer {
        id: player

        property int seekTarget: 0
        property bool seeking: false


        source: "file:///data/user/0/org.qtproject.example/files/sedecal_share_files/Closed bag protocol.mp4" //   Aquí puedes poner la ruta del archivo de audio o video
        autoPlay: true

        notifyInterval: 10

        onAvailabilityChanged: console.log("-----> MMP availability changed:", player.availability)
        onBufferProgressChanged: console.log("-----> MMP buffer progress changed:", player.bufferProgress)
        onErrorChanged: console.log("-----> MMP Error cahnged:", player.error, player.errorString)
        onHasVideoChanged: console.log("-----> MMP has video changed:", player.hasVideo)
        onNotifyIntervalChanged: console.log("-----> MMP notify interval changed:", player.notifyInterval)
        onPlaybackRateChanged: console.log("-----> MMP playback rate changed:", player.playbackRate)
        onPlaylistChanged: console.log("-----> MMP play list changed:", player.playlist)
        onPositionChanged: console.log("-----> MMP position changed:", player.position)
        onDurationChanged: console.log("-----> MMP duration changed:", player.duration)
        onStatusChanged: console.log("-----> MMP status changed:", player.status)
        onSeekableChanged: console.log("-----> MMP sekeable changed:", player.seekable)
        onLoopsChanged: console.log("-----> MMP looops changed:", player.loops)
        onSourceChanged: console.log("-----> MMP source changed:", player.source)


        onPlaybackStateChanged: {
            switch(player.playbackState) {
                            case MediaPlayer.StoppedState:
                                playPauseControl.source = "/Images/baseline_play_arrow_white_24.png"
                                break
                            case MediaPlayer.PausedState:
                                playPauseControl.source = "/Images/baseline_play_arrow_white_24.png"
                                break
                            case MediaPlayer.PlayingState:
                                playPauseControl.source = "/Images/baseline_pause_white_24.png"
                                break
                        }
            console.log("-----> MMP playback state changed:", player.playbackState)
        }

        //loops: MediaPlayer.Infinite  // Repetir el video indefinidamente
    }

    Rectangle{
        id: controlCanvas
        width: parent.width * 0.8
        height: width * (mmIsLandScape ? 0.1 : 0.15)
        color: "grey"
        opacity: 0.5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: height * 0.25
        radius: height * 0.1
    }

    Row {
        id: controlsGroup
        anchors.centerIn: controlCanvas
        anchors.verticalCenterOffset:  - controlCanvas.height * 0.08
        spacing: 20
        Image {
            id: rwControl
            height: controlCanvas.height * 0.7
            width: height
            source: "/Images/baseline_rf_white_24.png"
            MouseArea{
                anchors.fill: parent
                onClicked: {
//                  player.seekTarget = player.position;
//                  console.log("seekTarget: ", player.seekTarget)
//                  player.seekTarget = player.seekTarget - 3000
//                  console.log("seekTarget after: ", player.seekTarget)
//                  player.stop()
//                  player.playbackRate = 20
//                  player.play()
//                  player.seeking = true
//                  //Qt.createQmlObject('import QtQuick 2.15; Timer { interval: 1000; running: true; repeat: false; onTriggered: { player.playbackRate = 1; player.notifyInterval = 1000} }', player);

                    var newPos = player.position - 3000;
                    player.seek(newPos > 0 ? newPos : 0); // Retroceder 3 segundos
                }
            }
        }
        Image {
            id: playPauseControl
            height: controlCanvas.height * 0.7
            width: height
            source: "/Images/baseline_pause_white_24.png"
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if (player.playbackState === MediaPlayer.PlayingState) {
                        player.pause()
                    } else {
                        player.play()
                    }
                }
            }
        }
        Image {
            id: stopControl
            height: controlCanvas.height * 0.7
            width: height
            source: "/Images/baseline_stop_white_24.png"
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    player.stop()
                }
            }
        }
        Image {
            id: ffControl
            height: controlCanvas.height * 0.7
            width: height
            source: "/Images/baseline_ff_white_24.png"
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    var newPos = player.position + 3000;
                    player.seek(newPos > player.duration ? player.duration : newPos);
                }
            }
        }
    }

    Slider {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: controlsGroup.bottom

        id: slider
        from: 0
        to: player.duration
        value: player.position
        handle: Item {
                 width: 0
                 height: 0
             }
        width: controlCanvas.width * 0.95
//        onValueChanged: {
//            if(player.seeking){
//                if(player.position >= player.seekTarget)
//                {
//                    if(player.playbackRate > 1){
//                        player.playbackRate = 1;
//                        player.seeking = false
//                    }
//                }
//            }
//            if(player.position >= player.duration){
//              //player.stop()
//                player.playbackRate = 1;
//                player.seeking = false
//                console.log("Automatic stop............................................")
//            }
////          console.log("video duration:", player.duration, "- position:", player.position, "-seekeable:", player.seekable, "status:", player.status, "availability:", player.availability,"*******************************************")
//        }
    }

    TextArea {
        id: durationText
        height: slider.width * 0.045
        width: slider.width
        anchors.right: slider.right
        anchors.bottom: slider.top
        text: millisecondsToTime(player.position) + " - " + millisecondsToTime(player.duration)
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment:  Text.AlignRight
        font.pixelSize: height * 0.5
        color: "white"
    }

    // Mostrar el progreso de reproducción
    Timer {
        id: progressTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            /////  slider.value = player.position
        }
    }
}
