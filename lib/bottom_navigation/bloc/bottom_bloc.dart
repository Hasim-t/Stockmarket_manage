import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bottom_event.dart';
part 'bottom_state.dart';

class BottomBloc extends Bloc<BottomEvent, BottomState> {
  BottomBloc() : super(BottomInitial()) {

    on<ChangeingEvent>((event, emit) {
      
      emit(Bottomchnagestate(event.value));
    });
  }
}
