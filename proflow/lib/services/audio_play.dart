import 'package:dart_vlc/dart_vlc.dart';

final player = Player(
  id: 69420,
  commandlineArguments: ['--no-video'],
);

void playAsset(String assetUrl) {
  final file = Media.asset(assetUrl);
  player.open(file, autoStart: false);
  player.play();
}

void playNetword(String networkUrl) {
  final network = Media.network(networkUrl);
  player.open(network, autoStart: false);
  player.play();
}
