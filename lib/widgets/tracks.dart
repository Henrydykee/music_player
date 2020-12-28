import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/player.dart';

class Tracks extends StatefulWidget {
  @override
  _TracksState createState() => _TracksState();
}

class _TracksState extends State<Tracks> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<SongInfo> songs = [];
  final GlobalKey<PlayerState> key = GlobalKey<PlayerState>();
  var currentIndex = 0;

  @override
  void initState() {
    getTracks();
    super.initState();
  }

  void getTracks() async {
    songs = await audioQuery.getSongs();
    setState(() {
      songs = songs;
    });
  }

  void changeTracks(bool isNext){
    if(isNext){
      if(currentIndex !=songs.length-1){
        currentIndex++;
      }else{
        if(currentIndex !=0){
          currentIndex--;
        }
      }
    }
    key.currentState.setSong(songs[currentIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Audio Player",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
      ),
      body: ListView.separated(
        itemCount: songs.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                currentIndex = index;
              });

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Player(
                        songInfo: songs[currentIndex],
                    changeTrack: changeTracks,
                    key: key,
                      )));
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: songs[index].albumArtwork == null
                    ? AssetImage("assets/images/paly_music.png")
                    : songs[index].albumArtwork,
              ),
              title: Text(songs[index].title),
              subtitle: Text(songs[index].artist),
            ),
          );
        },
      ),
    );
  }
}
