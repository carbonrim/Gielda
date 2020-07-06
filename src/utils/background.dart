import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marketplace/src/utils/empty.dart';
import 'package:animated_background/animated_background.dart';

class Background extends StatefulWidget {
  final Color color1;
  final Color color2;
  Background({this.color1 = Colors.amber, this.color2 = Colors.blue});
  @override
  State<StatefulWidget> createState() {
    return BackgroundState();
  }
}

class BackgroundState extends State<Background> with TickerProviderStateMixin {
  var particlePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;
  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: -50,
        left: -50,
        width: MediaQuery.of(context).size.width + 100,
        height: MediaQuery.of(context).size.height + 100,
        child: Stack(
          children: <Widget>[
            AnimatedBackground(
              behaviour: RandomParticleBehaviour(
                  paint: particlePaint,
                  options: ParticleOptions(
                    baseColor: widget.color1,
                    spawnOpacity: 0.0,
                    opacityChangeRate: 0.1,
                    minOpacity: 0.0,
                    maxOpacity: 0.8,
                    spawnMinSpeed: 5.0,
                    spawnMaxSpeed: 15.0,
                    spawnMinRadius: 5.0,
                    spawnMaxRadius: 20.0,
                    particleCount: 100,
                  )),
              vsync: this,
              child: Empty(),
            ),
            AnimatedBackground(
              behaviour: RandomParticleBehaviour(
                  paint: particlePaint,
                  options: ParticleOptions(
                    baseColor: widget.color2,
                    spawnOpacity: 0.0,
                    opacityChangeRate: 0.1,
                    minOpacity: 0.0,
                    maxOpacity: 0.7,
                    spawnMinSpeed: 5.0,
                    spawnMaxSpeed: 15.0,
                    spawnMinRadius: 5.0,
                    spawnMaxRadius: 20.0,
                    particleCount: 140,
                  )),
              vsync: this,
              child: Empty(),
            ),
          ],
        ));
  }
}
