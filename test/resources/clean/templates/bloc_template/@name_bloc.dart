import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part '@name_event.dart';
part '@name_state.dart';

class @Name extends Bloc<@NameEvent, @NameState> {
  @override
  @NameState get initialState => @NameInitial();

  @override
  Stream<@NameState> mapEventToState(
    @NameEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
