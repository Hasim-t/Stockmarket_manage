part of 'bottom_bloc.dart';

@immutable
sealed class BottomState {}

final class BottomInitial extends BottomState {}

class Bottomchnagestate extends BottomState {
  final int current;

  ontap(int value) {
    value = current;
  }

  Bottomchnagestate(this.current);
}
