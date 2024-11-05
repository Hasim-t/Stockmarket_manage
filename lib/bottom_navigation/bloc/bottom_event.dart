part of 'bottom_bloc.dart';

@immutable
sealed class BottomEvent {}

class ChangeingEvent extends BottomEvent {
  final int value;
  
  ChangeingEvent({required this.value});
}
