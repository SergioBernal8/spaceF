import 'dart:collection';
import 'dart:math';

import 'package:rxdart/rxdart.dart';
import 'package:space_f/space/space.dart';

class SpaceBloc {
  final BehaviorSubject<int> _subject;
  final ValueObservable<int> stream;
  var rdm = Random();
  StarModel max;
  HashSet<StarModel> str = HashSet(hashCode: (v) => v.x.toInt());

  factory SpaceBloc() => SpaceBloc._(subject: BehaviorSubject<int>());

  SpaceBloc._({BehaviorSubject<int> subject})
      : _subject = subject,
        stream = subject.stream;

  generateStars() async {
    for (var i = 0; i < 10; i++) {
      var st = 0;
      while (st < 20)
        if (str.add(await _getRandomStr((max.y * (i / 10)).toInt()))) {
          st++;
          _subject.add(1);
        }
    }
    _subject.add(0);
  }

  onTap(StarModel str) {
    if (str.x % 2 == 0 && str.y % 2 == 0 && str.color == B) _subject.add(2);
  }

  Future<StarModel> _getRandomStr(int y) async {
    await Future.delayed(Duration(milliseconds: 50), () {});
    return StarModel(
        color: getColor(),
        x: rdm.nextInt(max.x),
        y: y + rdm.nextInt((max.y * 0.1).toInt()));
  }

  getColor() {
    var r = rdm.nextInt(10);
    return r == 0 ? Y : r == 1 ? B : W;
  }
}
