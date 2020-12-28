

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';

class Player extends StatefulWidget {
  SongInfo songInfo;
  Function changeTrack;
  final GlobalKey<PlayerState> key;

  Player({@required this.songInfo,this.changeTrack, this.key}) : super(key: key);

  @override
  PlayerState createState() => PlayerState();
}

class PlayerState extends State<Player> {
  double minimumValue= 0.0;
  double maximumValue= 0.0;
  double currentValue= 0.0;
  String currentTime = "";
  String endTime= "";
  bool isPlaying = false;

  final AudioPlayer audioPlayer = AudioPlayer();


  @override
  void initState() {
    setSong(widget.songInfo);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer?.dispose();
  }

  void changeStatus(){
    setState(() {
      isPlaying = !isPlaying;
    });
    if(isPlaying){
      audioPlayer.play();
    }else{
      audioPlayer.pause();
    }
  }

  void setSong(SongInfo songInfo) async{
    widget.songInfo =  songInfo;
    await audioPlayer.setUrl(widget.songInfo.uri);
    currentValue = minimumValue;
    maximumValue = audioPlayer.duration.inMilliseconds.toDouble();
    setState(() {
      currentTime = getDuration(currentValue);
      endTime = getDuration(maximumValue);
    });
    changeStatus();
    audioPlayer.positionStream.listen((duration) {
      currentValue= duration.inMilliseconds.toDouble();
      setState(() {
        currentTime = getDuration(currentValue);
      });
    });
  }


  String getDuration(double value){
    Duration duration = Duration(milliseconds:  value.round());
    return [duration.inMinutes, duration.inSeconds].map((e) => e.remainder(60).toString().padLeft(2,'0')).join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back,color: Colors.black,),
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(5, 40, 5, 0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: widget.songInfo.albumArtwork == null ? AssetImage("assets/images/paly_music.png") : FileImage(File(widget.songInfo.albumArtwork)) ,
              radius: 95,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 7,),
              child: Text(widget.songInfo.title,style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w600
              ),),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 15,),
              child: Text(widget.songInfo.artist,style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.0,
              ),),
            ),
            // Slider(
            //   inactiveColor: Colors.black12,
            //     activeColor: Colors.black,
            //     min: maximumValue,
            //     max: maximumValue,
            //     value: currentValue,
            //     onChanged: (value){
            //     currentValue= value;
            //     audioPlayer.seek(Duration(milliseconds: currentValue.round()));
            //     }
            // ),
            Container(
              transform: Matrix4.translationValues(0, -7, 0),
              margin: EdgeInsets.fromLTRB(5, 0, 5, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(currentTime,style: TextStyle(color: Colors.grey, fontSize: 12.5, fontWeight: FontWeight.w500),),
                  Text(endTime,style: TextStyle(color: Colors.grey, fontSize: 12.5, fontWeight: FontWeight.w500),)
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      child: Icon(Icons.skip_previous,color: Colors.black,size: 55),
                    behavior: HitTestBehavior.translucent,
                    onTap: (){
                        widget.changeTrack(false);
                    },
                  ),
                  GestureDetector(
                    child: Icon(isPlaying?Icons.pause:Icons.play_arrow,color: Colors.black,size: 75),
                    behavior: HitTestBehavior.translucent,
                    onTap: (){
                      changeStatus();
                    },
                  ),
                  GestureDetector(
                    child: Icon(Icons.skip_next,color: Colors.black,size: 55),
                    behavior: HitTestBehavior.translucent,
                    onTap: (){
                      widget.changeTrack(true);
                    },
                  )

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
