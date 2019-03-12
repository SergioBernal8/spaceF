import 'dart:collection';
import 'dart:math';

import 'package:rxdart/rxdart.dart';
import 'package:space_f/space/space.dart';

class SpaceBloc {
  final BehaviorSubject<int> _subject;
  final ValueObservable<int> stream;
  var ram = Random();
  StarModel maxPos;
  HashSet<StarModel> stars = HashSet(hashCode: (v) => v.x.toInt());

  factory SpaceBloc() => SpaceBloc._(subject: BehaviorSubject<int>());

  SpaceBloc._({BehaviorSubject<int> subject})
      : _subject = subject,
        stream = subject.stream;

  generateStars() async {
    for (var i = 0; i < 10; i++) {
      var str = 0;
      while (str < 20)
        if (stars.add(await _getRandomStr((maxPos.y * (i / 10)).toInt()))) {
          str++;
          _subject.add(1);
        }
    }
    _subject.add(0);
  }

  onTap(StarModel str) {
    if (str.x % 2 == 0 && str.y % 2 == 0) _subject.add(2);
  }

  Future<StarModel> _getRandomStr(int y) async {
    await Future.delayed(Duration(milliseconds: 50), () {});

    return StarModel(
        color: getColor(),
        x: ram.nextInt(maxPos.x),
        y: y + ram.nextInt((maxPos.y * 0.1).toInt()));
  }

  getColor() {
    var r = ram.nextInt(10);
    return r == 0 ? Y : r == 1 ? B : W;
  }
}
