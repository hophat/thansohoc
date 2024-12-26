// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioProvider {
  static AudioProvider? _instance;
  static AudioProvider get I {
    _instance ??= AudioProvider._();
    return _instance!;
  }
  AudioProvider._();
  // final AudioPlayer _audioPlayer = AudioPlayer();

  playBg() {
    // if(_audioPlayer.state == PlayerState.playing) {
    //   return;
    // }
    // _audioPlayer.setVolume(0.5);
    // _audioPlayer.setReleaseMode(ReleaseMode.loop);
    // _audioPlayer.play(AssetSource('audio/spring_bg.mp3'));
  }

  stopBg() {
    // _audioPlayer.stop();
  }
}