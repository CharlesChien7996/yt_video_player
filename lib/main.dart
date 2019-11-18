import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Youtube Player',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.grey[850],
          textTheme: TextTheme(
            title: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 24.0,
            ),
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.grey[850],
        ),
      ),
      home: MyHomePage(),
    );
  }
}

/// Homepage
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  YoutubePlayerController _controller;
  YoutubeMetaData _videoMetaData;
  bool _muted = false;
  bool _isPlayerReady = false;
  int count = 0;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'ZgYm09cRnxo',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        disableDragSeek: false,
        forceHideAnnotation: true,
      ),
    )..addListener(listener);
    _videoMetaData = YoutubeMetaData();
  }

  void listener() {
    if (_isPlayerReady && !_controller.value.isFullScreen) {
      setState(() {
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildButtonSection() {
    return Container(
      margin: EdgeInsets.all(16.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
            onPressed: _isPlayerReady
                ? () {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                    setState(() {});
                  }
                : null,
          ),
          IconButton(
            icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
            onPressed: _isPlayerReady
                ? () {
                    _muted ? _controller.unMute() : _controller.mute();
                    setState(() {
                      _muted = !_muted;
                    });
                  }
                : null,
          ),
          FullScreenButton(
            controller: _controller,
            color:  Colors.grey[850],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Text(
          'Youtube Player Flutter',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            YoutubePlayer(
              progressColors: ProgressBarColors(playedColor: Colors.red, backgroundColor: Colors.red, bufferedColor: Colors.red, handleColor: Colors.red),
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.grey,
              onReady: () {
                setState(() {
                  _isPlayerReady = true;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                _videoMetaData.title,
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
            _buildButtonSection()
          ],
        ),
      ),
    );
  }
}
