import 'package:flutter/material.dart';
import 'package:space_f/space/space.dart';
import 'package:space_f/space/space_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext ctx) => MaterialApp(home: Space(SpaceBloc()));
}
