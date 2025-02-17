import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerCard extends StatefulWidget {
  AudioPlayerCard({this.color, this.file, this.id, this.isMe});
  final String? file;
  final String? id;
  final Color? color;
  final bool? isMe;
  @override
  _AudioPlayerCardState createState() => _AudioPlayerCardState();
}

class _AudioPlayerCardState extends State<AudioPlayerCard>  {
  double totalDuration = 0.0, position = 0.0;
  Duration? startTime = Duration(), endTime = Duration();
  AudioPlayer _audioPlayer = AudioPlayer();
  Future<Duration?>? futureDuration;
  late StreamSubscription<PlayerState> _playerStateChangedSubscription;

  String _setDurationToStringFormat(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Future<void> play() {
    return _audioPlayer.play();
  }

  Future<void> pause() {
    return _audioPlayer.pause();
  }

  Future<void> reset() async {
    await _audioPlayer.stop();
    return _audioPlayer.seek(const Duration(milliseconds: 0));
  }

  void playerStateListener(PlayerState state) async {
    if (state.processingState == ProcessingState.completed) {
      await reset();
    }
  }

  Future<void> _initAudioPlayer() async {
    _playerStateChangedSubscription = _audioPlayer.playerStateStream.listen(playerStateListener);
    futureDuration = _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(widget.file!)));
  }

  @override
  void dispose() {
    _playerStateChangedSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _initAudioPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Duration?>(
      future: futureDuration,
      builder: (context, snapshot) {
          return Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(widget.isMe! ? 5 : 30),
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(widget.isMe! ? 30 : 5)),
              color: widget.color,
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(width: 5),
                  snapshot.hasData ?
                  _controlButtons() :
                  Icon(Icons.play_arrow, color: Colors.white, size: 25),
                  SizedBox(width: 5),
                  _slider(snapshot.data, snapshot.hasData),
                ],
              ),
            ),
          );
      },
    );
  }

  Widget _slider(Duration? duration, bool hasData) {
    return StreamBuilder<Duration>(
      stream: _audioPlayer.positionStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && duration != null) {
          totalDuration = duration.inMilliseconds.toDouble();
          position = snapshot.data!.inMilliseconds.toDouble();
          endTime = duration;
          startTime = snapshot.data;
        }
        return Row(
          children: [
            Text(
              hasData == true ? _setDurationToStringFormat(startTime!) + '/' + _setDurationToStringFormat(endTime!) :
              'Loading...',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
            SliderTheme(
              data: SliderThemeData(
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7)),
              child: Slider(
                thumbColor: Colors.white,
                activeColor: Colors.white,
                inactiveColor: Colors.white54,
                value: position,
                min: 0,
                max: totalDuration,
                onChanged: (double val) {
                  setState(() {
                    _audioPlayer.seek(duration! * val);
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _controlButtons() {
    return StreamBuilder<bool>(
      stream: _audioPlayer.playingStream,
      builder: (context, _) {
        return GestureDetector(
          child: Icon(
            _audioPlayer.playerState.playing ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
            size: 25,
          ),
          onTap: () {
            if (_audioPlayer.playerState.playing) {
              pause();
            } else {
              play();
            }
          },
        );
      },
    );
  }
}