import 'dart:collection';
import 'dart:math';

import 'package:rxdart/rxdart.dart';
import 'package:space_f/space/space.dart';

class SpaceBloc {
  final BehaviorSubject<int> _subject;
  final ValueObservable<int> stream;
  var rdm = Random();
  STR max;
  HashSet<STR> str = HashSet(hashCode: (v) => v.x);

  factory SpaceBloc() => SpaceBloc._(subject: BehaviorSubject<int>());

  SpaceBloc._({BehaviorSubject<int> subject})
      : _subject = subject,
        stream = subject.stream;

  generateStars() async {
    for (var i = 0; i < 10; i++) {
      var st = 0;
      while (st < 20)
        if (str.add(await _getStr((max.y * (i / 10)).toInt()))) {
          st++;
          _subject.add(1);
        }
    }
    _subject.add(0);
  }

  onTap(STR str) {
    if (str.x % 2 == 0 && str.y % 2 == 0 && str.color == B) _subject.add(2);
  }

  Future<STR> _getStr(int y) async {
    await Future.delayed(Duration(milliseconds: 50), () {});
    return STR(
        color: getC(),
        size: getS(),
        x: rdm.nextInt(max.x),
        y: y + rdm.nextInt((max.y * 0.1).toInt()));
  }

  getC() {
    var c = rdm.nextInt(10);
    return c == 0 ? Y : c == 1 ? B : W;
  }

  getS() => 3 + rdm.nextInt(3);
}
