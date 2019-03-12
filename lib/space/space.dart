import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:space_f/space/space_bloc.dart';

const W = Colors.white;
const Y = Colors.yellow;
const B = Colors.lightBlueAccent;

class Space extends StatefulWidget {
  final SpaceBloc bloc;

  Space(this.bloc);

  @override
  _SpaceState createState() => _SpaceState();
}

class _SpaceState extends State<Space> {
  var conf = true;

  _setUp() {
    var m = MediaQuery.of(context).size;
    widget.bloc.max = StarModel(x: m.width.toInt(), y: m.height.toInt());
    if (m.width > 0 && m.height > 0) {
      conf = false;
      widget.bloc.generateStars();
    }
  }

  Widget build(_) {
    if (conf) _setUp();
    var stl = TextStyle(color: W, fontSize: 24);
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder(
          stream: widget.bloc.stream,
          initialData: 0,
          builder: (_, snapshot) {
            return snapshot.data == 2
                ? Center(
                    child: ScalingText(
                    "You've found the Flutter 🌟!",
                    style: stl,
                  ))
                : Stack(
                    children: <Widget>[
                      Center(
                        child: snapshot.data == 1
                            ? JumpingText(
                                'Loading...⏳',
                                style: stl,
                              )
                            : Container(),
                      ),
                      Stack(
                          children: widget.bloc.str
                              .map((str) => Star(
                                    key: ObjectKey(str),
                                    mod: str,
                                    tap: () => widget.bloc.onTap(str),
                                  ))
                              .toList())
                    ],
                  );
          }),
    );
  }
}

class Star extends StatefulWidget {
  final StarModel mod;
  final Function tap;
  final Key key;

  Star({this.key, this.mod, this.tap}) : super(key: key);

  @override
  _StarState createState() => _StarState();
}

class _StarState extends State<Star> with SingleTickerProviderStateMixin {
  AnimationController _ctr;
  Animation<Color> _anim;

  @override
  void initState() {
    _ctr = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _anim = ColorTween(
            begin: widget.mod.color.withOpacity(0.2), end: widget.mod.color)
        .animate(_ctr);

    _ctr.addListener(() {
      if (_ctr.isCompleted) {
        _ctr.reverse().then((_) => _ctr.forward());
      }
    });
    _ctr.forward();
    super.initState();
  }

  @override
  Widget build(_) => Positioned(
        top: widget.mod.y.toDouble(),
        left: widget.mod.x.toDouble(),
        width: 3,
        height: 3,
        child: InkWell(
          onTap: widget.tap,
          child: Transform.rotate(
            angle: 45 * (math.pi / 180),
            child: AnimatedBuilder(
              animation: _anim,
              builder: (_, __) => Container(
                    color: _anim.value,
                  ),
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _ctr.dispose();
    super.dispose();
  }
}

class StarModel {
  final int x, y;
  final Color color;

  StarModel({this.x, this.y, this.color});

  @override
  bool operator ==(o) => o is StarModel && x == o.x && y == o.y;

  @override
  int get hashCode => super.hashCode;
}
